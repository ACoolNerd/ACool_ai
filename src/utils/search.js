export function filterGpts(gpts, search = "", activeCluster = null) {
  const query = search.toLowerCase().trim();

  return gpts.filter((gpt) => {
    const clusterMatch = !activeCluster || gpt.cluster === activeCluster;
    const searchMatch = !query || [
      gpt.name,
      gpt.title,
      gpt.cluster,
      gpt.status,
      ...(gpt.capabilities || [])
    ].join(" ").toLowerCase().includes(query);

    return clusterMatch && searchMatch;
  });
}
