import { spawn } from "child_process";

async function checkCommandExists(command: string): Promise<boolean> {
  return new Promise((resolve) => {
    const check = spawn("which", [command]);
    check.on("close", (code) => {
      resolve(code === 0);
    });
    check.on("error", () => {
      resolve(false);
    });
  });
}

async function checkWhisperInstallation(): Promise<string> {
  const commands = ["whisper", "whisper-cli", "whisper.cpp"];

  for (const cmd of commands) {
    if (await checkCommandExists(cmd)) {
      return cmd;
    }
  }

  throw new Error(
    "whisper.cpp not found. Please install it:\n" +
      "git clone https://github.com/ggerganov/whisper.cpp.git\n" +
      "cd whisper.cpp && make\n" +
      "Or specify the path with --whisper-bin option",
  );
}

export async function transcribe(
  audioFile: string,
  modelPath?: string,
  language: string = "ja",
): Promise<string> {
  const whisperBin = await checkWhisperInstallation();
  const model = modelPath || "./models/ggml-base.bin";

  return new Promise((resolve, reject) => {
    const args = [
      "-m",
      model,
      "-f",
      audioFile,
      "-l",
      language,
      "--no-timestamps",
      "-otxt",
      "-of",
      "-",
    ];

    const whisper = spawn(whisperBin, args);
    let output = "";
    let errorOutput = "";

    whisper.stdout.on("data", (data) => {
      output += data.toString();
    });

    whisper.stderr.on("data", (data) => {
      errorOutput += data.toString();
    });

    whisper.on("close", (code) => {
      if (code === 0) {
        resolve(output.trim());
      } else {
        reject(new Error(`whisper failed: ${errorOutput || output}`));
      }
    });

    whisper.on("error", (err) => {
      reject(new Error(`Failed to run whisper: ${err.message}`));
    });
  });
}
