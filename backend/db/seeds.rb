# ===========================================
# Database Seeds
# ===========================================

puts "Seeding database..."

# ===========================================
# Admin User
# ===========================================
puts "Creating admin user..."
AdminUser.find_or_create_by!(email: ENV.fetch('ADMIN_EMAIL', 'admin@example.com').downcase) do |admin|
  admin.name = 'Admin'
  admin.password = ENV.fetch('ADMIN_PASSWORD', 'password123')
end
puts "Admin user created: #{ENV.fetch('ADMIN_EMAIL', 'admin@example.com')}"

# ===========================================
# Site Settings
# ===========================================
puts "Seeding site settings..."
SiteSetting.seed_defaults!

# Update with sample data
SiteSetting.set('owner_name', 'John Doe', 'string')
SiteSetting.set('site_tagline', 'Full-Stack Developer', 'string')
SiteSetting.set('owner_bio', "I'm a passionate full-stack developer with expertise in building modern web applications. I love turning complex problems into elegant, user-friendly solutions.\n\nWith experience across the entire stack - from crafting pixel-perfect UIs to architecting scalable backend systems - I bring ideas to life through clean, maintainable code.", 'text')
SiteSetting.set('owner_location', 'San Francisco, CA', 'string')
SiteSetting.set('owner_email', 'hello@example.com', 'string')
SiteSetting.set('github_url', 'https://github.com/johndoe', 'string')
SiteSetting.set('linkedin_url', 'https://linkedin.com/in/johndoe', 'string')
SiteSetting.set('twitter_url', 'https://twitter.com/johndoe', 'string')
SiteSetting.set('available_for_work', 'true', 'boolean')

# ===========================================
# Skills
# ===========================================
puts "Seeding skills..."

skills_data = [
  # Frontend
  { name: 'JavaScript', category: 'frontend', proficiency: 95, icon_class: 'devicon-javascript-plain' },
  { name: 'TypeScript', category: 'frontend', proficiency: 90, icon_class: 'devicon-typescript-plain' },
  { name: 'React', category: 'frontend', proficiency: 90, icon_class: 'devicon-react-original' },
  { name: 'Vue.js', category: 'frontend', proficiency: 80, icon_class: 'devicon-vuejs-plain' },
  { name: 'HTML/CSS', category: 'frontend', proficiency: 95, icon_class: 'devicon-html5-plain' },
  { name: 'Tailwind CSS', category: 'frontend', proficiency: 90, icon_class: 'devicon-tailwindcss-plain' },
  
  # Backend
  { name: 'Ruby on Rails', category: 'backend', proficiency: 95, icon_class: 'devicon-rails-plain' },
  { name: 'Node.js', category: 'backend', proficiency: 85, icon_class: 'devicon-nodejs-plain' },
  { name: 'Python', category: 'backend', proficiency: 80, icon_class: 'devicon-python-plain' },
  { name: 'Go', category: 'backend', proficiency: 70, icon_class: 'devicon-go-original-wordmark' },
  
  # Database
  { name: 'PostgreSQL', category: 'database', proficiency: 90, icon_class: 'devicon-postgresql-plain' },
  { name: 'Redis', category: 'database', proficiency: 85, icon_class: 'devicon-redis-plain' },
  { name: 'MongoDB', category: 'database', proficiency: 75, icon_class: 'devicon-mongodb-plain' },
  
  # DevOps
  { name: 'Docker', category: 'devops', proficiency: 90, icon_class: 'devicon-docker-plain' },
  { name: 'AWS', category: 'devops', proficiency: 80, icon_class: 'devicon-amazonwebservices-original' },
  { name: 'CI/CD', category: 'devops', proficiency: 85, icon_class: 'devicon-github-original' },
  { name: 'Nginx', category: 'devops', proficiency: 80, icon_class: 'devicon-nginx-original' },
  
  # Tools
  { name: 'Git', category: 'tools', proficiency: 95, icon_class: 'devicon-git-plain' },
  { name: 'VS Code', category: 'tools', proficiency: 95, icon_class: 'devicon-vscode-plain' },
  { name: 'Figma', category: 'tools', proficiency: 75, icon_class: 'devicon-figma-plain' }
]

skills_data.each_with_index do |skill_attrs, index|
  Skill.find_or_create_by!(name: skill_attrs[:name], category: skill_attrs[:category]) do |skill|
    skill.proficiency = skill_attrs[:proficiency]
    skill.icon_class = skill_attrs[:icon_class]
    skill.position = index
  end
end

puts "Created #{Skill.count} skills"

# ===========================================
# Projects
# ===========================================
puts "Seeding projects..."

projects_data = [
  {
    title: 'E-Commerce Platform',
    short_description: 'A full-featured online store with payment processing and inventory management.',
    description: "Built a complete e-commerce solution featuring product catalog management, shopping cart functionality, secure checkout with Stripe integration, and an admin dashboard for inventory and order management.\n\nKey features include real-time inventory tracking, customer accounts, order history, and automated email notifications.",
    live_url: 'https://example-store.com',
    github_url: 'https://github.com/johndoe/ecommerce',
    status: 'published',
    featured: true,
    technologies: ['Ruby on Rails', 'React', 'PostgreSQL', 'Redis', 'Docker']
  },
  {
    title: 'Task Management App',
    short_description: 'A collaborative project management tool with real-time updates.',
    description: "Developed a Trello-like task management application with drag-and-drop boards, real-time collaboration features, and team workspaces.\n\nImplemented WebSocket connections for live updates, file attachments, comment threads, and activity logging.",
    live_url: 'https://taskapp.example.com',
    github_url: 'https://github.com/johndoe/taskapp',
    status: 'published',
    featured: true,
    technologies: ['Vue.js', 'Node.js', 'MongoDB', 'Docker']
  },
  {
    title: 'API Gateway Service',
    short_description: 'A high-performance API gateway with rate limiting and authentication.',
    description: "Designed and built a centralized API gateway service handling authentication, rate limiting, request routing, and analytics for microservices architecture.\n\nFeatures include JWT validation, request/response transformation, caching, and comprehensive logging.",
    github_url: 'https://github.com/johndoe/api-gateway',
    status: 'published',
    featured: true,
    technologies: ['Go', 'Redis', 'Docker', 'Nginx']
  },
  {
    title: 'Analytics Dashboard',
    short_description: 'Real-time analytics dashboard with customizable widgets.',
    description: "Created an interactive analytics platform featuring real-time data visualization, customizable dashboards, and automated reporting.\n\nBuilt with React and D3.js for dynamic charts and graphs, with a Python backend for data processing.",
    live_url: 'https://analytics.example.com',
    status: 'published',
    featured: false,
    technologies: ['React', 'TypeScript', 'Python', 'PostgreSQL']
  },
  {
    title: 'Chat Application',
    short_description: 'Real-time messaging app with end-to-end encryption.',
    description: "Built a secure messaging application with end-to-end encryption, group chats, file sharing, and push notifications.\n\nImplemented using WebSockets for real-time communication and Redis for message queuing.",
    github_url: 'https://github.com/johndoe/chatapp',
    status: 'published',
    featured: false,
    technologies: ['React', 'Node.js', 'Redis', 'PostgreSQL']
  }
]

projects_data.each_with_index do |project_attrs, index|
  technologies = project_attrs.delete(:technologies)
  
  project = Project.find_or_create_by!(title: project_attrs[:title]) do |p|
    p.short_description = project_attrs[:short_description]
    p.description = project_attrs[:description]
    p.live_url = project_attrs[:live_url]
    p.github_url = project_attrs[:github_url]
    p.status = project_attrs[:status]
    p.featured = project_attrs[:featured]
    p.position = index
  end
  
  # Add technologies
  technologies&.each do |tech_name|
    skill = Skill.find_by(name: tech_name)
    if skill && !project.technologies.include?(skill)
      project.technologies << skill
    end
  end
end

puts "Created #{Project.count} projects"

# ===========================================
# Experience
# ===========================================
puts "Seeding experience..."

experiences_data = [
  {
    company: 'Tech Startup Inc.',
    role: 'Senior Full-Stack Developer',
    location: 'San Francisco, CA',
    start_date: Date.new(2022, 1, 1),
    end_date: nil,
    current: true,
    description: 'Leading development of the core product platform, mentoring junior developers, and architecting scalable solutions.',
    highlights: [
      'Reduced API response times by 60% through optimization',
      'Led migration from monolith to microservices architecture',
      'Implemented CI/CD pipeline reducing deployment time by 80%',
      'Mentored team of 4 junior developers'
    ]
  },
  {
    company: 'Digital Agency Co.',
    role: 'Full-Stack Developer',
    location: 'Los Angeles, CA',
    start_date: Date.new(2019, 6, 1),
    end_date: Date.new(2021, 12, 31),
    current: false,
    description: 'Developed custom web applications and e-commerce solutions for various clients.',
    highlights: [
      'Built 15+ client projects from concept to deployment',
      'Introduced automated testing increasing code coverage to 85%',
      'Developed reusable component library used across projects'
    ]
  },
  {
    company: 'Software Solutions Ltd.',
    role: 'Junior Developer',
    location: 'Remote',
    start_date: Date.new(2017, 9, 1),
    end_date: Date.new(2019, 5, 31),
    current: false,
    description: 'Started my professional development career building internal tools and maintaining legacy applications.',
    highlights: [
      'Modernized legacy PHP application to Ruby on Rails',
      'Developed internal admin dashboard used by 50+ employees',
      'Participated in agile development process'
    ]
  }
]

experiences_data.each_with_index do |exp_attrs, index|
  Experience.find_or_create_by!(company: exp_attrs[:company], role: exp_attrs[:role]) do |exp|
    exp.location = exp_attrs[:location]
    exp.start_date = exp_attrs[:start_date]
    exp.end_date = exp_attrs[:end_date]
    exp.current = exp_attrs[:current]
    exp.description = exp_attrs[:description]
    exp.highlights = exp_attrs[:highlights]
    exp.position = index
  end
end

puts "Created #{Experience.count} experiences"

# ===========================================
# Testimonials
# ===========================================
puts "Seeding testimonials..."

testimonials_data = [
  {
    author_name: 'Sarah Johnson',
    author_title: 'Product Manager',
    author_company: 'Tech Startup Inc.',
    content: 'Working with John has been an absolute pleasure. His technical expertise combined with his ability to understand business requirements makes him an invaluable team member. He consistently delivers high-quality work ahead of schedule.',
    rating: 5,
    featured: true
  },
  {
    author_name: 'Michael Chen',
    author_title: 'CTO',
    author_company: 'Digital Agency Co.',
    content: 'John is one of the most talented developers I\'ve worked with. His attention to detail and commitment to writing clean, maintainable code sets him apart. He\'s also a great communicator who keeps stakeholders informed throughout the development process.',
    rating: 5,
    featured: true
  },
  {
    author_name: 'Emily Rodriguez',
    author_title: 'Founder',
    author_company: 'StartupXYZ',
    content: 'John helped us build our MVP in record time. His full-stack expertise meant we could move quickly without compromising on quality. I highly recommend him for any web development project.',
    rating: 5,
    featured: false
  }
]

testimonials_data.each_with_index do |test_attrs, index|
  Testimonial.find_or_create_by!(author_name: test_attrs[:author_name], author_company: test_attrs[:author_company]) do |test|
    test.author_title = test_attrs[:author_title]
    test.content = test_attrs[:content]
    test.rating = test_attrs[:rating]
    test.featured = test_attrs[:featured]
    test.position = index
  end
end

puts "Created #{Testimonial.count} testimonials"

# ===========================================
# Blog Posts
# ===========================================
puts "Seeding blog posts..."

posts_data = [
  {
    title: 'Building Modern Web Applications with Rails and HTMX',
    slug: 'rails-htmx-modern-web',
    excerpt: 'Learn how to create dynamic, interactive web applications without the complexity of a full JavaScript framework.',
    content: "In this post, I'll show you how HTMX can revolutionize your Rails development workflow by enabling dynamic updates without writing JavaScript.\n\nHTMX allows you to access modern browser features directly from HTML, making it perfect for Rails developers who want to build interactive applications while keeping things simple.\n\n## Why HTMX?\n\nHTMX extends HTML as a hypertext, giving you access to AJAX, CSS Transitions, WebSockets and Server Sent Events directly in HTML. This means you can build modern UIs without the complexity of React, Vue, or Angular.\n\n## Getting Started\n\nFirst, add HTMX to your Rails application...",
    status: 'published',
    published_at: 3.days.ago,
    tags: ['rails', 'htmx', 'web-development']
  },
  {
    title: 'Docker Best Practices for Ruby on Rails Applications',
    slug: 'docker-rails-best-practices',
    excerpt: 'A comprehensive guide to containerizing your Rails applications for development and production.',
    content: "Containerizing Rails applications can significantly improve your development workflow and deployment process. In this guide, I'll share best practices I've learned from years of working with Docker and Rails.\n\n## Multi-stage Builds\n\nOne of the most important techniques for production Docker images is using multi-stage builds. This allows you to separate your build dependencies from your runtime dependencies, resulting in smaller, more secure images.\n\n## Development vs Production\n\nYour development and production Docker configurations should be different...",
    status: 'published',
    published_at: 1.week.ago,
    tags: ['docker', 'rails', 'devops']
  },
  {
    title: 'PostgreSQL Performance Tuning for Web Applications',
    slug: 'postgresql-performance-tuning',
    excerpt: 'Optimize your database queries and configuration for better application performance.',
    content: "Database performance is often the bottleneck in web applications. In this post, I'll cover practical PostgreSQL optimization techniques that can significantly improve your application's response times.\n\n## Query Optimization\n\nThe first step to better database performance is understanding how to write efficient queries. We'll look at using EXPLAIN ANALYZE to understand query execution plans...",
    status: 'published',
    published_at: 2.weeks.ago,
    tags: ['postgresql', 'database', 'performance']
  },
  {
    title: 'Building Real-time Features with ActionCable',
    slug: 'realtime-actioncable',
    excerpt: 'Add live updates, notifications, and chat features to your Rails application.',
    content: "ActionCable makes it easy to add real-time features to your Rails applications using WebSockets. In this tutorial, we'll build a live notification system from scratch.\n\n## Setting Up ActionCable\n\nActionCable is included with Rails by default. Let's configure it to use Redis as the adapter...",
    status: 'draft',
    published_at: nil,
    tags: ['rails', 'websockets', 'realtime']
  }
]

posts_data.each do |post_attrs|
  Post.find_or_create_by!(slug: post_attrs[:slug]) do |post|
    post.title = post_attrs[:title]
    post.excerpt = post_attrs[:excerpt]
    post.content = post_attrs[:content]
    post.status = post_attrs[:status]
    post.published_at = post_attrs[:published_at]
    post.tags = post_attrs[:tags]
  end
end

puts "Created #{Post.count} posts"

# ===========================================
# Sample Messages
# ===========================================
puts "Seeding sample messages..."

messages_data = [
  {
    name: 'Alice Smith',
    email: 'alice@example.com',
    subject: 'Project Inquiry',
    content: "Hi! I came across your portfolio and I'm really impressed with your work. We're looking for a developer to help build our new e-commerce platform. Would you be available for a call next week to discuss the project?",
    project_type: 'freelance',
    read: false
  },
  {
    name: 'Bob Johnson',
    email: 'bob@techstartup.com',
    subject: 'Full-time Opportunity',
    content: "Hello! I'm the hiring manager at TechStartup and we're looking for senior full-stack developers. Your experience with Rails and React looks like a great fit for our team. Would you be interested in learning more about the position?",
    project_type: 'full-time',
    read: true
  }
]

messages_data.each do |msg_attrs|
  Message.find_or_create_by!(email: msg_attrs[:email], subject: msg_attrs[:subject]) do |msg|
    msg.name = msg_attrs[:name]
    msg.content = msg_attrs[:content]
    msg.project_type = msg_attrs[:project_type]
    msg.read = msg_attrs[:read]
  end
end

puts "Created #{Message.count} messages"

puts "\n✅ Seeding complete!"
puts "=" * 50
puts "Admin login: #{ENV.fetch('ADMIN_EMAIL', 'admin@example.com')}"
puts "Admin password: #{ENV.fetch('ADMIN_PASSWORD', 'password123')}"
puts "=" * 50
