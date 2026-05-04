export async function copyToClipboard(text) {
  if (!navigator?.clipboard) {
    throw new Error("Clipboard API unavailable");
  }
  await navigator.clipboard.writeText(text);
}
