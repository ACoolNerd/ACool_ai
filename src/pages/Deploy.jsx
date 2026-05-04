import SectionHeader from "../components/shared/SectionHeader";

export default function Deploy() {
  return (
    <section>
      <SectionHeader title="Deploy" subtitle="GitHub + Vercel deployment path." />
      <div className="document-card">
        <h3>Commands</h3>
        <pre>{`npm install
npm run dev
npm run build
git add .
git commit -m "Productize ACoolECOSYSTEM Unified AI OS"
git push -u origin main`}</pre>
      </div>
    </section>
  );
}
