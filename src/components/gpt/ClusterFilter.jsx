    setTimeout(() => setCopied(false), 1500);
  }

  return (
    <article className="gpt-card" style={{ borderLeftColor: cluster?.color || "#f59e0b" }}>
      <button className="gpt-card-header" onClick={() => setOpen(!open)}>
        <div>
          <div className="gpt-title-row">
            <h3>{gpt.name}</h3>
            <Badge color={cluster?.color}>{cluster?.name}</Badge>
            <Badge color="#10b981">Phase {gpt.phase}</Badge>
          </div>
          <p>{gpt.title}</p>
        </div>
        <span>{open ? "▲" : "▼"}</span>
      </button>

      {open && (
        <div className="gpt-detail">
          <h4>System Prompt</h4>
          <pre>{gpt.prompt}</pre>

          <h4>Welcome Message</h4>
          <blockquote>{gpt.welcome}</blockquote>

          <h4>Capabilities</h4>
          <div className="capability-row">
            {gpt.capabilities.map((capability) => <span key={capability}>{capability}</span>)}
          </div>

          <div className="action-row">
            <button onClick={handleCopy}>{copied ? "Copied ✓" : "Copy Prompt"}</button>
            <button className="secondary" onClick={() => setDeployOpen(!deployOpen)}>
              {deployOpen ? "Hide Deploy Guide" : "Deploy to ChatGPT"}
            </button>
          </div>

          {deployOpen && (
            <div className="deploy-box">
              <strong>Deploy {gpt.name}</strong>
              <ol>
                <li>Open ChatGPT → Explore GPTs → Create.</li>
                <li>Paste the system prompt into Instructions.</li>
                <li>Set name to {gpt.name}.</li>
                <li>Add related docs from Notion/Drive.</li>
                <li>Publish to workspace.</li>
              </ol>
            </div>
          )}
        </div>
      )}
    </article>
  );
}
