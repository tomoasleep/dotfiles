#!/bin/bash
set -eu

task_id=''
task_name=''
status=''
sender=''
event='task_update'
details='{}'
ts=''
file_path="${VIBEDUMP_FILE:-.vibedump.jsonl}"

usage() {
  printf '%s\n' "Usage: vibedump-log.sh --task-id ID --task-name NAME --status STATUS --sender SENDER [--event EVENT] [--details JSON] [--ts ISO8601] [--file PATH]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --task-id)
      task_id="$2"
      shift 2
      ;;
    --task-name)
      task_name="$2"
      shift 2
      ;;
    --status)
      status="$2"
      shift 2
      ;;
    --sender)
      sender="$2"
      shift 2
      ;;
    --event)
      event="$2"
      shift 2
      ;;
    --details)
      details="$2"
      shift 2
      ;;
    --ts)
      ts="$2"
      shift 2
      ;;
    --file)
      file_path="$2"
      shift 2
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      printf '%s\n' "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$task_id" || -z "$task_name" || -z "$status" || -z "$sender" ]]; then
  usage
  exit 1
fi

if [[ -z "$ts" ]]; then
  ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
fi

if ! command -v jq >/dev/null 2>&1; then
  printf '%s\n' 'jq is required'
  exit 1
fi

log_line="$(jq -cn \
  --arg ts "$ts" \
  --arg event "$event" \
  --arg sender "$sender" \
  --arg status "$status" \
  --arg task_id "$task_id" \
  --arg task_name "$task_name" \
  --argjson details "$details" \
  '{ts:$ts,event:$event,sender:$sender,status:$status,task_id:$task_id,task_name:$task_name,details:$details}')"

printf '%s\n' "$log_line" >> "$file_path"
