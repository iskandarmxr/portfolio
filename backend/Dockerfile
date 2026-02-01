# ===========================================
# Backend Dockerfile - Multi-stage build
# ===========================================

# Stage 1: Development (includes all dependencies)
FROM ruby:3.3-alpine AS development

RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    git \
    nodejs \
    npm \
    curl \
    tzdata \
    gcompat \
    yaml-dev \
    imagemagick \
    imagemagick-dev

WORKDIR /app

COPY Gemfile ./
RUN bundle install --jobs 4

COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

# Stage 2: Builder (for production assets)
FROM ruby:3.3-alpine AS builder

RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    git \
    nodejs \
    npm \
    yaml-dev \
    imagemagick \
    imagemagick-dev

WORKDIR /app

COPY Gemfile ./
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4

COPY . .

# Precompile assets
RUN SECRET_KEY_BASE=dummy RAILS_ENV=production \
    bundle exec rails assets:precompile

# Stage 3: Production Runtime
FROM ruby:3.3-alpine AS production

RUN apk add --no-cache \
    postgresql-client \
    tzdata \
    curl \
    gcompat \
    imagemagick

WORKDIR /app

# Copy application and dependencies from builder
COPY --from=builder /app /app
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Create non-root user
RUN adduser -D -u 1000 rails && \
    chown -R rails:rails /app

USER rails

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
