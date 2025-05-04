# 📚 GPT Book Creator for ComputerCraft

This project allows you to **generate entire books using ChatGPT directly from ComputerCraft** (or CC: Tweaked) inside Minecraft.  
The AI-generated content is saved, uploaded to Pastebin, and organized via a favorite system.  
It uses a **Node.js proxy server** to access the OpenAI API, since ComputerCraft has no native HTTPS support.

---

## ✨ Features

- 📖 Create books using the ChatGPT API (via a custom prompt)
- 🛰️ Node.js proxy to bridge OpenAI and ComputerCraft
- 📤 Automatic Pastebin upload of the book content
- 🔖 Save and manage book links (title + URL) in a `book_favorites.txt` file
- 🖥️ Works 100% in ComputerCraft (no shell redirection hacks)
- 🧠 AI-generated creative content, formatted and exported

---

## 🛠️ Requirements

### On your ComputerCraft setup:
- Minecraft with the **CC: Tweaked** mod (recommended)
- Internet access (via `http` API)
- A valid **Pastebin account with developer key** (`pastebin set key <your_key>`)

### On your external machine (proxy):
- A Linux VPS (Debian/Ubuntu recommended)
- Node.js (v18+)
- Access to your **OpenAI API key**

---

## 🌐 How It Works

1. You input a book title or prompt from the ComputerCraft terminal.
2. The prompt is sent to a Node.js proxy, which relays it to the OpenAI API.
3. The AI response (book content) is saved locally in a `.txt` file.
4. The file is uploaded to Pastebin via `pastebin put`.
5. The paste link is automatically extracted and stored in `book_favorites.txt`.

---

## 🧪 How to Use

### 1. 🧠 Start the Proxy Server

Install dependencies:

```bash
npm install express cors body-parser dotenv openai
```

Create a `.env` file:
```
OPENAI_API_KEY=your_openai_key
```
Run the proxy:

```
node server.js
```
Make sure port 3000 is open and reachable from your Minecraft host.

###  2. 🖥️ In ComputerCraft
Place the main Lua script (book_creator.lua) on a computer.

Run it:

```
livre-gpt
```
Follow the prompt to input your book idea/title.

Example:

Enter book title:
The Secrets of Redstone
The AI will generate the content, upload it, and save the link:

txt
Copy
Edit
{
  title = "The Secrets of Redstone",
  link = "https://pastebin.com/abc12345",
},
🧾 Files
`livre-gpt.lua` – main Lua script for ComputerCraft

`index.js` – Node.js proxy server

`.env` – OpenAI API key (not committed)

`book_favorites.txt` – list of your saved books

`livre.txt` – raw text file of each book

---

# 🔐 Security
Your OpenAI key is stored server-side (never exposed to CC).

Communication between CC and the proxy is over **HTTP**, so only run this on trusted local networks or protected servers.

Never expose your proxy endpoint publicly without auth.
