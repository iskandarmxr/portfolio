# Full-Stack Developer Portfolio

A modern, responsive portfolio application built with Ruby on Rails, HTMX, and a dark glassmorphism design. Features a separated frontend/backend architecture with a full CMS admin panel.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                          Browser                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌──────────────────┐           ┌──────────────────────────┐   │
│   │    Frontend      │           │       Backend            │   │
│   │  (Nginx Static)  │           │    (Rails API + Admin)   │   │
│   │                  │   HTMX    │                          │   │
│   │  - HTML Pages    │ ───────►  │  - Fragment API          │   │
│   │  - CSS/JS        │           │  - Admin Panel           │   │
│   │  - Assets        │           │  - WebSockets            │   │
│   └──────────────────┘           └──────────────────────────┘   │
│                                             │                   │
│                                             ▼                   │
│                          ┌──────────────────────────────┐       │
│                          │    PostgreSQL + Redis        │       │
│                          └──────────────────────────────┘       │
└─────────────────────────────────────────────────────────────────┘
```

## Features

### Public Portfolio
- **Hero Section** - Dynamic intro with live visitor count
- **Projects** - Filterable project showcase with modal details
- **Skills** - Interactive skill grid with proficiency levels
- **Experience** - Expandable work history timeline
- **Blog** - Full blog with search and categories
- **Testimonials** - Client testimonials carousel
- **Contact** - Form with project type selector

### Admin CMS
- **Dashboard** - Stats, recent messages, analytics
- **Projects CRUD** - Full management with image uploads
- **Blog Posts** - Rich text editor with drafts
- **Messages** - Inbox with read/unread status
- **Skills/Experience** - Drag-drop reordering
- **Settings** - Site configuration

### Technical
- **HTMX** - Dynamic content without JavaScript frameworks
- **ActionCable** - Real-time visitor counter and notifications
- **Glassmorphism** - Modern dark theme design
- **Responsive** - Mobile-first, 11 breakpoints, foldable support
- **Docker** - Full containerization with docker-compose

## Quick Start

### Prerequisites
- Docker & Docker Compose
- Git

### Setup (No Configuration Needed!)

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/portfolio.git
cd portfolio

# 2. Start all services
docker-compose up --build

# 3. In another terminal, setup the database
docker-compose exec backend rails db:create db:migrate db:seed

# 4. Open in browser
# Frontend: http://localhost
# Admin:    http://localhost/admin
```

### Default Admin Credentials
- **Email:** admin@example.com
- **Password:** password123

That's it! No `.env` file needed for local development - defaults are built into `docker-compose.yml`.

### Optional: Custom Configuration

If you want to customize settings, create a `.env` file:
```bash
cp .env.example .env
# Edit .env with your values - they will override the defaults
```

## Project Structure

```
portfolio/
├── frontend/                    # Static HTML/CSS/JS (Nginx)
│   ├── public/
│   │   ├── index.html
│   │   ├── about.html
│   │   ├── projects.html
│   │   ├── blog.html
│   │   ├── contact.html
│   │   └── assets/
│   │       ├── css/main.css
│   │       └── js/app.js
│   ├── nginx.conf
│   └── Dockerfile
│
├── backend/                     # Rails API + Admin
│   ├── app/
│   │   ├── controllers/
│   │   │   ├── fragments/       # HTML Fragment API
│   │   │   └── admin/           # Admin Panel
│   │   ├── models/
│   │   ├── views/
│   │   │   ├── fragments/       # HTMX partials
│   │   │   └── admin/           # Admin ERB views
│   │   └── channels/            # ActionCable
│   ├── config/
│   ├── db/
│   ├── Gemfile
│   └── Dockerfile
│
├── docker-compose.yml
├── docker-compose.override.yml  # Development overrides
├── .env.example
└── README.md
```

## API Endpoints

### Fragment API (HTMX)

All endpoints return HTML fragments for HTMX swapping:

| Endpoint | Description |
|----------|-------------|
| `GET /fragments/hero` | Hero section content |
| `GET /fragments/about` | About section with stats |
| `GET /fragments/projects` | Projects grid |
| `GET /fragments/projects/:id` | Project detail modal |
| `GET /fragments/projects/filter/:tech` | Filter by technology |
| `GET /fragments/skills` | Skills grouped by category |
| `GET /fragments/experience` | Work history timeline |
| `GET /fragments/posts` | Blog posts grid |
| `GET /fragments/posts/:slug` | Single blog post |
| `GET /fragments/posts/search?q=` | Search posts |
| `GET /fragments/testimonials` | Testimonials list |
| `POST /fragments/contact` | Submit contact form |

### Admin Routes

| Route | Description |
|-------|-------------|
| `GET /admin` | Dashboard |
| `GET /admin/projects` | Manage projects |
| `GET /admin/posts` | Manage blog posts |
| `GET /admin/messages` | View messages |
| `GET /admin/skills` | Manage skills |
| `GET /admin/experiences` | Manage experience |
| `GET /admin/testimonials` | Manage testimonials |
| `GET /admin/settings` | Site settings |
| `GET /admin/analytics` | View analytics |

## Development

### Running locally without Docker

**Backend (Rails):**
```bash
cd backend
bundle install
rails db:create db:migrate db:seed
rails server
```

**Frontend (static files):**
Serve the `frontend/public` directory with any static server.

### Running tests
```bash
cd backend
bundle exec rspec
```

### Linting
```bash
cd backend
bundle exec rubocop
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_PASSWORD` | PostgreSQL password | - |
| `SECRET_KEY_BASE` | Rails secret key | - |
| `ADMIN_EMAIL` | Admin login email | admin@example.com |
| `ADMIN_PASSWORD` | Admin login password | - |
| `FRONTEND_URL` | Frontend URL for CORS | http://localhost |
| `REDIS_URL` | Redis connection URL | redis://redis:6379/0 |

## Design System

The portfolio uses a custom dark glassmorphism design inspired by [grilledpixels.com](https://www.grilledpixels.com/).

### Colors
- **Background**: Pure black (#000000)
- **Accent**: Red (#dc2626) for CTAs
- **Primary**: Violet (#8b5cf6) for secondary elements
- **Glass**: Translucent white with blur

### Typography
- **Display**: Bebas Neue (headlines)
- **Body**: Space Grotesk (paragraphs)
- **Mono**: JetBrains Mono (code, labels)

### Breakpoints
- 375px: Small phones
- 523px: Foldable phones (unfolded)
- 768px: Tablets
- 1024px: Small laptops
- 1280px: Laptops
- 1440px: Desktops
- 1920px: Full HD
- 2560px: 4K / Ultra-wide

## Deployment

### Production Docker
```bash
docker-compose -f docker-compose.yml up -d
```

### Manual Deployment
1. Build Rails assets: `RAILS_ENV=production rails assets:precompile`
2. Set environment variables
3. Run migrations: `RAILS_ENV=production rails db:migrate`
4. Start Puma: `RAILS_ENV=production bundle exec puma`

## License

MIT License - feel free to use this for your own portfolio!

## Contributing

Contributions are welcome! Please open an issue or PR.

## Credits

- Design inspiration: [Grilled Pixels](https://www.grilledpixels.com/)
- Admin design inspiration: [DAdmin](https://themelooks.net/demo/dadmin/)
- Icons: [Lucide](https://lucide.dev/)
- Fonts: Google Fonts
