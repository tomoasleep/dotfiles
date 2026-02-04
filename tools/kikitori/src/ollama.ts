import { Ollama } from 'ollama';
import { readFile } from 'fs/promises';

const ollama = new Ollama({ host: 'http://localhost:11434' });

export async function refineText(text: string, model: string = 'llama3.2'): Promise<string> {
  const prompt = `以下の文字起こしテキストを整形してください。句読点を適切に追加し、文章を自然な形に整えてください。余計な説明は不要で、整形後のテキストのみを出力してください。

${text}`;

  try {
    const response = await ollama.chat({
      model,
      messages: [{ role: 'user', content: prompt }],
      stream: false
    });
    return response.message.content.trim();
  } catch (error) {
    if (error instanceof Error && error.message.includes('fetch failed')) {
      throw new Error(
        'Ollama server not running. Please start it:\n' +
        'ollama serve'
      );
    }
    throw error;
  }
}

export async function formatWithPrompt(text: string, templatePath: string, model: string = 'llama3.2'): Promise<string> {
  const template = await readFile(templatePath, 'utf-8');
  const prompt = template.replace('{{transcription}}', text);

  try {
    const response = await ollama.chat({
      model,
      messages: [{ role: 'user', content: prompt }],
      stream: false
    });
    return response.message.content.trim();
  } catch (error) {
    if (error instanceof Error && error.message.includes('fetch failed')) {
      throw new Error(
        'Ollama server not running. Please start it:\n' +
        'ollama serve'
      );
    }
    throw error;
  }
}
