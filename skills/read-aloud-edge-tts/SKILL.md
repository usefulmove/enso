---
name: read-aloud-edge-tts
description: Read text or markdown files aloud to the user using the edge-tts CLI tool. Use this when the user asks to have a file, document, or text read to them.
license: MIT
compatibility: opencode
---

## When to Use

- The user asks you to "read this file to me" or "read this aloud".
- The user is having trouble reading a long markdown document and wants an audio version.
- The user wants to listen to the contents of a text file while doing something else.

---

## Workflow

### 1. Check for `edge-tts`
Before attempting to read a file, ensure `edge-tts` is installed on the system.
Run:
```bash
which edge-tts
```
If it is not found, install it using pipx (recommended for isolated CLI tools):
```bash
pipx install edge-tts
```

### 2. Prepare the Text
If the file is a Markdown file, you should strip the formatting characters (like `#`, `*`, `_`) so the TTS engine doesn't read them out loud as "hash hash hash".

**Always collapse newlines to spaces** before reading. TTS engines treat `\n` as a pause marker, which makes poetry and formatted text sound choppy. Pipe through `tr '\n' ' ' | sed 's/  */ /g'` to produce natural flowing speech.

### 3. Read Aloud
Use a bash pipeline to read the file, strip formatting (if necessary), and pipe it to `edge-tts`, which then pipes the audio to `ffplay` (or another audio player like `mpv` or `aplay`).

For Markdown files:
```bash
cat <file_path> | sed -e 's/[#*_]//g' | tr '\n' ' ' | sed 's/  */ /g' | edge-tts --voice en-US-AriaNeural --file - | ffplay -nodisp -autoexit -loglevel quiet -i -
```

For plain text files:
```bash
cat <file_path> | tr '\n' ' ' | sed 's/  */ /g' | edge-tts --voice en-US-AriaNeural --file - | ffplay -nodisp -autoexit -loglevel quiet -i -
```

*Note: `en-US-AriaNeural` is a high-quality default voice. Other good options include `en-US-ChristopherNeural` or `en-GB-SoniaNeural`.*

### 4. Handle Audio Issues
If the command succeeds but the user reports hearing no sound, advise them that it might be a system audio issue (e.g., PulseAudio or PipeWire configuration) and suggest they check their volume and output device settings.

---

## Checklist

- [ ] `edge-tts` is installed and available in the PATH.
- [ ] Markdown formatting is stripped before reading (if applicable).
- [ ] Newlines are collapsed to spaces for natural speech flow.
- [ ] The file is successfully read aloud using `edge-tts`.
