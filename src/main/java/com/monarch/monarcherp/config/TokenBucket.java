package com.monarch.monarcherp.config;

import java.util.concurrent.atomic.AtomicLong;

public class TokenBucket {
    private final long capacity = 50;
    private final long refillRatePerMs = 1;
    private final AtomicLong tokens;
    private long lastRefillTimestamp;

    public TokenBucket() {
        this.tokens = new AtomicLong(capacity);
        this.lastRefillTimestamp = System.currentTimeMillis();
    }

    public synchronized boolean allowRequest() {
        refill();
        if (tokens.get() > 0) {
            tokens.decrementAndGet();
            return true;
        }
        return false;
    }

    private void refill() {
        long now = System.currentTimeMillis();
        long timePassed = now - lastRefillTimestamp;

        long tokensToAdd = (timePassed * refillRatePerMs) / 1000;

        if (tokensToAdd > 0) {
            long newTokenCount = Math.min(capacity, tokens.get() + tokensToAdd);
            tokens.set(newTokenCount);
            lastRefillTimestamp = now;
        }
    }

    @Override
    public String toString() {
        return "TokenBucket{" +
                "tokens=" + tokens.get() +
                ", capacity=" + capacity +
                ", lastRefillTimestamp=" + lastRefillTimestamp +
                '}';
    }

}
