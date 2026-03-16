#!/usr/bin/env node

const args = process.argv.slice(2)
const options = {
  baseUrl: 'http://localhost:4096'
}

let i = 0
while (i < args.length) {
  const arg = args[i]

  if (arg === '--help' || arg === '-h') {
    console.log('Usage: node extract-session-messages.js [--base-url URL] [--session-id ID] [--project-id ID] [--dir-prefix PATH]')
    process.exit(0)
  }

  if (arg === '--base-url') {
    options.baseUrl = args[i + 1]
    i += 2
    continue
  }
  if (arg.startsWith('--base-url=')) {
    options.baseUrl = arg.slice('--base-url='.length)
    i += 1
    continue
  }

  if (arg === '--session-id') {
    options.sessionId = args[i + 1]
    i += 2
    continue
  }
  if (arg.startsWith('--session-id=')) {
    options.sessionId = arg.slice('--session-id='.length)
    i += 1
    continue
  }

  if (arg === '--project-id') {
    options.projectId = args[i + 1]
    i += 2
    continue
  }
  if (arg.startsWith('--project-id=')) {
    options.projectId = arg.slice('--project-id='.length)
    i += 1
    continue
  }

  if (arg === '--dir-prefix') {
    options.dirPrefix = args[i + 1]
    i += 2
    continue
  }
  if (arg.startsWith('--dir-prefix=')) {
    options.dirPrefix = arg.slice('--dir-prefix='.length)
    i += 1
    continue
  }

  console.error(`Unknown argument: ${arg}`)
  process.exit(1)
}

const baseUrl = options.baseUrl.replace(/\/$/, '')

const fetchJson = async (path) => {
  const res = await fetch(`${baseUrl}${path}`)
  if (!res.ok) {
    const text = await res.text()
    throw new Error(`Request failed: ${res.status} ${res.statusText} ${text}`)
  }
  return res.json()
}

const extractText = (parts) => {
  if (!parts) return ''
  return parts
    .filter((part) => part.type === 'text')
    .map((part) => part.text)
    .join('\n')
}

const formatMessage = (entry) => {
  const { info, parts } = entry
  return {
    role: info.role,
    time: info.time,
    text: extractText(parts)
  }
}

const run = async () => {
  let sessions

  if (options.sessionId) {
    sessions = [await fetchJson(`/session/${options.sessionId}`)]
  } else {
    sessions = await fetchJson('/session')
  }

  if (options.projectId) {
    sessions = sessions.filter((session) => session.projectID === options.projectId)
  }

  if (options.dirPrefix) {
    sessions = sessions.filter((session) => session.directory.startsWith(options.dirPrefix))
  }

  const results = []

  for (const session of sessions) {
    const messages = await fetchJson(`/session/${session.id}/message`)
    const userMessages = messages.filter((entry) => entry.info.role === 'user')
    let lastAssistant = null

    for (const entry of messages) {
      if (entry.info.role === 'assistant') {
        lastAssistant = entry
      }
    }

    const outputMessages = userMessages.map(formatMessage)
    if (lastAssistant) {
      outputMessages.push(formatMessage(lastAssistant))
    }

    results.push({
      session: {
        id: session.id,
        title: session.title,
        directory: session.directory,
        projectID: session.projectID,
        time: session.time
      },
      messages: outputMessages
    })
  }

  console.log(JSON.stringify({ sessions: results }, null, 2))
}

run().catch((error) => {
  console.error(error.message)
  process.exit(1)
})
