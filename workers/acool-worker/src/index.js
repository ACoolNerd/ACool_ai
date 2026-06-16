import { createClient } from 'redis';
import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const redis = createClient({
  socket: {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT || '6379'),
  },
  password: process.env.REDIS_PASSWORD || undefined,
});

const pool = new Pool({
  host: process.env.POSTGRES_HOST,
  port: process.env.POSTGRES_PORT || 5432,
  database: process.env.POSTGRES_DB,
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
});

redis.on('error', (err) => console.error('Redis error:', err));

async function processJobs() {
  try {
    await redis.connect();
    console.log('✓ ACool Worker started');
    console.log('✓ Redis connected');

    while (true) {
      try {
        const job = await redis.lPop('acool:jobs');
        if (job) {
          const data = JSON.parse(job);
          console.log(`Processing job: ${data.type}`);
        }
        await new Promise(resolve => setTimeout(resolve, 5000));
      } catch (error) {
        console.error('Job processing error:', error);
      }
    }
  } catch (error) {
    console.error('Startup error:', error);
    process.exit(1);
  }
}

processJobs();
