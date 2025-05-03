import express from "express";
import fetch from "node-fetch";
import dotenv from "dotenv";
dotenv.config();
const app = express();
const port = 80;

app.get('/generate', async (req, res) => {
  const prompt = req.query.prompt;
  if (!prompt) return res.status(400).send("Missing 'prompt' parameter.");

  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${process.env.OPENAI_API_KEY}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7,
        max_tokens: 800
      })
    });

    const data = await response.json();

    if (data.error) {
      console.error(data.error);
      return res.status(500).send("OpenAI error: " + data.error.message);
    }

    const content = data.choices?.[0]?.message?.content || "No content.";
    res.send(content);
  } catch (err) {
    console.error(err);
    res.status(500).send("Internal error.");
  }
});

app.listen(port, () => {
  console.log(`Proxy GPT running at http://localhost:${port}`);
});
