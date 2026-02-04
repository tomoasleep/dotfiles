import { Command } from 'commander';
import { recordAudio, cleanupAudioFile } from './recorder.js';
import { transcribe } from './whisper.js';
import { refineText, formatWithPrompt } from './ollama.js';

interface CliOptions {
  template?: string;
  model?: string;
  duration?: number;
  language?: string;
  refine?: boolean;
  ollamaModel?: string;
}

const program = new Command();

program
  .name('kikitori')
  .description('Whisper + Ollama powered transcription CLI')
  .version('0.1.0')
  .option('-t, --template <path>', 'template file path (used as LLM prompt)')
  .option('-m, --model <path>', 'whisper model file path', './models/ggml-base.bin')
  .option('--ollama-model <name>', 'ollama model name', 'llama3.2')
  .option('-d, --duration <seconds>', 'recording duration in seconds', parseInt)
  .option('-l, --language <code>', 'language code', 'ja')
  .option('--no-refine', 'skip ollama refinement')
  .action(async (options: CliOptions) => {
    let audioFile: string | undefined;

    try {
      audioFile = await recordAudio(options.duration);
      const transcription = await transcribe(audioFile, options.model, options.language);

      let result = transcription;
      if (options.template) {
        result = await formatWithPrompt(transcription, options.template, options.ollamaModel);
      } else if (options.refine !== false) {
        result = await refineText(transcription, options.ollamaModel);
      }

      console.log(result);
    } catch (error) {
      console.error('Error:', error instanceof Error ? error.message : String(error));
      process.exit(1);
    } finally {
      if (audioFile) {
        await cleanupAudioFile(audioFile);
      }
    }
  });

program.parse();
