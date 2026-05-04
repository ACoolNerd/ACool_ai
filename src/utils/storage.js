export function getStoredJSON(key, fallback) {
  try {
    const value = localStorage.getItem(key);
    return value ? JSON.parse(value) : fallback;
  } catch {
    return fallback;
  }
}

export function setStoredJSON(key, value) {
  localStorage.setItem(key, JSON.stringify(value));
}
