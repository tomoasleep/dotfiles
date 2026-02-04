import { spawn } from "child_process";
import { mkdtemp, unlink } from "fs/promises";
import { tmpdir } from "os";
import { join } from "path";
import { createInterface } from "readline";

export async function recordAudio(duration?: number): Promise<string> {
  const tmpDir = await mkdtemp(join(tmpdir(), "kikitori-"));
  const outputFile = join(tmpDir, "recording.wav");

  return new Promise((resolve, reject) => {
    const args = [
      "-d",
      "-t",
      "wav",
      "-r",
      "16000",
      "-c",
      "1",
      "-b",
      "16",
      outputFile,
    ];

    if (duration) {
      args.push("trim", "0", String(duration));
    }

    const sox = spawn("sox", args);
    let isFinished = false;

    const cleanup = () => {
      if (!isFinished) {
        isFinished = true;
        sox.kill("SIGINT");
      }
    };

    sox.on("close", (code) => {
      if (code === 0 || code === null || code === 130) {
        resolve(outputFile);
      } else {
        reject(new Error(`sox exited with code ${code}`));
      }
    });

    sox.on("error", (err) => {
      reject(new Error(`Failed to start sox: ${err.message}`));
    });

    process.on("SIGINT", cleanup);

    if (!duration) {
      console.error("Recording started... (Press Enter or Ctrl+D to stop)");

      const rl = createInterface({
        input: process.stdin,
        output: process.stdout,
      });

      rl.on("line", () => {
        cleanup();
        rl.close();
      });

      rl.on("close", () => {
        if (!isFinished) {
          cleanup();
        }
      });

      sox.on("close", () => {
        rl.close();
      });
    }
  });
}

export async function cleanupAudioFile(filePath: string): Promise<void> {
  try {
    await unlink(filePath);
  } catch {
    // Ignore cleanup errors
  }
}
