/**
 * Portfolio Application JavaScript
 * HTMX Configuration and WebSocket Setup
 */

// ===========================================
// Theme Toggle (runs immediately to prevent flash)
// ===========================================
(function initTheme() {
  const savedTheme = localStorage.getItem('portfolio-frontend-theme') || 'dark';
  document.documentElement.setAttribute('data-theme', savedTheme);
})();

// Theme toggle functionality
const ThemeToggle = {
  storageKey: 'portfolio-frontend-theme',
  
  init() {
    // Create and inject toggle into navbar
    this.injectToggle();
    
    // Set up event listeners
    const toggleInput = document.getElementById('theme-toggle-input');
    if (toggleInput) {
      const currentTheme = localStorage.getItem(this.storageKey) || 'dark';
      toggleInput.checked = currentTheme === 'light';
      
      toggleInput.addEventListener('change', () => {
        this.toggle();
      });
    }
  },
  
  injectToggle() {
    // Find the navbar
    const navbar = document.querySelector('.navbar');
    if (!navbar) return;
    
    // Check if toggle already exists
    if (document.querySelector('.theme-toggle')) return;
    
    // Find the nav-cta or nav-toggle to insert before
    const navCta = navbar.querySelector('.nav-cta');
    const navToggleMobile = navbar.querySelector('.nav-toggle');
    
    // Create toggle HTML
    const toggleHTML = `
      <div class="theme-toggle">
        <input type="checkbox" id="theme-toggle-input" class="theme-toggle-input">
        <label for="theme-toggle-input" class="theme-toggle-label" title="Toggle theme">
          <svg class="theme-toggle-icon sun" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 2.25a.75.75 0 01.75.75v2.25a.75.75 0 01-1.5 0V3a.75.75 0 01.75-.75zM7.5 12a4.5 4.5 0 119 0 4.5 4.5 0 01-9 0zM18.894 6.166a.75.75 0 00-1.06-1.06l-1.591 1.59a.75.75 0 101.06 1.061l1.591-1.59zM21.75 12a.75.75 0 01-.75.75h-2.25a.75.75 0 010-1.5H21a.75.75 0 01.75.75zM17.834 18.894a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 10-1.061 1.06l1.59 1.591zM12 18a.75.75 0 01.75.75V21a.75.75 0 01-1.5 0v-2.25A.75.75 0 0112 18zM7.758 17.303a.75.75 0 00-1.061-1.06l-1.591 1.59a.75.75 0 001.06 1.061l1.591-1.59zM6 12a.75.75 0 01-.75.75H3a.75.75 0 010-1.5h2.25A.75.75 0 016 12zM6.697 7.757a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 00-1.061 1.06l1.59 1.591z"/>
          </svg>
          <svg class="theme-toggle-icon moon" viewBox="0 0 24 24" fill="currentColor">
            <path fill-rule="evenodd" d="M9.528 1.718a.75.75 0 01.162.819A8.97 8.97 0 009 6a9 9 0 009 9 8.97 8.97 0 003.463-.69.75.75 0 01.981.98 10.503 10.503 0 01-9.694 6.46c-5.799 0-10.5-4.701-10.5-10.5 0-4.368 2.667-8.112 6.46-9.694a.75.75 0 01.818.162z" clip-rule="evenodd"/>
          </svg>
          <span class="theme-toggle-ball"></span>
        </label>
      </div>
    `;
    
    // Insert toggle before nav-cta or nav-toggle
    const insertBefore = navCta || navToggleMobile;
    if (insertBefore) {
      insertBefore.insertAdjacentHTML('beforebegin', toggleHTML);
    }
  },
  
  toggle() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem(this.storageKey, newTheme);
    
    // Update checkbox state
    const toggleInput = document.getElementById('theme-toggle-input');
    if (toggleInput) {
      toggleInput.checked = newTheme === 'light';
    }
  },
  
  getTheme() {
    return localStorage.getItem(this.storageKey) || 'dark';
  }
};

// ===========================================
// HTMX Configuration
// ===========================================
document.addEventListener('DOMContentLoaded', () => {
  // Initialize theme toggle
  ThemeToggle.init();
  // Configure HTMX
  htmx.config.defaultSwapStyle = 'innerHTML';
  htmx.config.defaultSettleDelay = 100;
  htmx.config.timeout = 10000;
  
  // Add loading class during requests
  htmx.on('htmx:beforeRequest', (event) => {
    event.target.classList.add('htmx-loading');
  });
  
  htmx.on('htmx:afterRequest', (event) => {
    event.target.classList.remove('htmx-loading');
  });
  
  // Handle errors
  htmx.on('htmx:responseError', (event) => {
    console.error('HTMX Error:', event.detail);
    // Could show a toast notification here
  });
  
  // Close modal when clicking outside
  document.addEventListener('click', (event) => {
    const modal = document.getElementById('project-modal');
    if (modal && event.target === modal) {
      modal.innerHTML = '';
    }
  });
  
  // Close modal with Escape key
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      const modal = document.getElementById('project-modal');
      if (modal) {
        modal.innerHTML = '';
      }
    }
  });
});

// ===========================================
// ActionCable WebSocket Connection
// ===========================================
class PortfolioWebSocket {
  constructor() {
    this.socket = null;
    this.subscriptions = {};
    this.reconnectAttempts = 0;
    this.maxReconnectAttempts = 5;
    this.reconnectDelay = 1000;
  }
  
  connect() {
    // Determine WebSocket URL
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const host = window.location.host;
    const url = `${protocol}//${host}/cable`;
    
    try {
      this.socket = new WebSocket(url);
      
      this.socket.onopen = () => {
        console.log('WebSocket connected');
        this.reconnectAttempts = 0;
        this.resubscribe();
      };
      
      this.socket.onmessage = (event) => {
        this.handleMessage(JSON.parse(event.data));
      };
      
      this.socket.onclose = () => {
        console.log('WebSocket disconnected');
        this.attemptReconnect();
      };
      
      this.socket.onerror = (error) => {
        console.error('WebSocket error:', error);
      };
    } catch (error) {
      console.error('Failed to create WebSocket:', error);
    }
  }
  
  attemptReconnect() {
    if (this.reconnectAttempts < this.maxReconnectAttempts) {
      this.reconnectAttempts++;
      const delay = this.reconnectDelay * Math.pow(2, this.reconnectAttempts - 1);
      console.log(`Reconnecting in ${delay}ms (attempt ${this.reconnectAttempts})`);
      setTimeout(() => this.connect(), delay);
    }
  }
  
  subscribe(channel, identifier, callback) {
    const key = `${channel}:${identifier}`;
    this.subscriptions[key] = { channel, identifier, callback };
    
    if (this.socket && this.socket.readyState === WebSocket.OPEN) {
      this.sendSubscribe(channel, identifier);
    }
  }
  
  sendSubscribe(channel, identifier) {
    const command = {
      command: 'subscribe',
      identifier: JSON.stringify({ channel, ...identifier })
    };
    this.socket.send(JSON.stringify(command));
  }
  
  resubscribe() {
    Object.values(this.subscriptions).forEach(sub => {
      this.sendSubscribe(sub.channel, sub.identifier);
    });
  }
  
  handleMessage(data) {
    if (data.type === 'ping' || data.type === 'welcome' || data.type === 'confirm_subscription') {
      return;
    }
    
    if (data.message) {
      // Find matching subscription
      const identifier = JSON.parse(data.identifier || '{}');
      const key = `${identifier.channel}:${identifier.id || ''}`;
      const sub = this.subscriptions[key];
      
      if (sub && sub.callback) {
        sub.callback(data.message);
      }
      
      // Handle specific message types
      this.handleBroadcast(data.message);
    }
  }
  
  handleBroadcast(message) {
    // Handle visitor count updates
    if (message.type === 'visitor_count') {
      const countEl = document.getElementById('visitor-count');
      if (countEl) {
        countEl.textContent = message.count;
      }
    }
    
    // Handle new notifications
    if (message.type === 'notification') {
      this.showNotification(message);
    }

    // Handle real-time content updates from admin panel
    if (message.type === 'content_update') {
      this.handleContentUpdate(message);
    }
  }

  handleContentUpdate(message) {
    const { model, action, id, data } = message;
    console.log(`Content update: ${action} ${model}`, data);

    // Handle settings updates specially
    if (model === 'settings') {
      this.handleSettingsUpdate(data);
      this.showUpdateToast(model, action);
      return;
    }

    // Dispatch a custom event on the body that HTMX elements listen to
    // Event name format: content-refresh-{model}
    const eventName = `content-refresh-${model}`;
    console.log(`Dispatching event: ${eventName}`);
    
    // Dispatch event on body so all elements with "from:body" trigger can receive it
    document.body.dispatchEvent(new CustomEvent(eventName, {
      bubbles: true,
      detail: { model, action, id, data }
    }));

    // Also trigger htmx:trigger on specific elements for backwards compatibility
    const modelSelectors = {
      project: ['#featured-projects', '#projects-grid', '#all-projects', '#projects-container'],
      post: ['#recent-posts', '#blog-posts', '#posts-grid', '#post-content'],
      skill: ['#skills-content', '#skills-grid'],
      experience: ['#experience-content', '#experience-list'],
      testimonial: ['#testimonials-content', '#testimonials-grid']
    };

    const selectors = modelSelectors[model] || [];
    selectors.forEach(selector => {
      const element = document.querySelector(selector);
      if (element && element.hasAttribute('hx-get')) {
        htmx.trigger(element, eventName);
      }
    });

    // Show toast notification for updates
    this.showUpdateToast(model, action);
  }

  handleSettingsUpdate(settings) {
    console.log('Settings updated:', settings);

    // Update "Open to work" status
    const statusDot = document.querySelector('.status-dot');
    const statusText = document.querySelector('.footer-status span:last-child');
    if (statusDot && statusText) {
      if (settings.available_for_work) {
        statusDot.classList.add('available');
        statusDot.classList.remove('unavailable');
        statusText.textContent = 'Open to work';
      } else {
        statusDot.classList.remove('available');
        statusDot.classList.add('unavailable');
        statusText.textContent = 'Not available';
      }
    }

    // Update site name in nav logo if present
    const navLogoText = document.querySelector('.nav-logo span:last-child');
    if (navLogoText && settings.site_name) {
      navLogoText.textContent = settings.site_name;
    }

    // Update document title
    if (settings.site_name) {
      const currentTitle = document.title;
      const titleParts = currentTitle.split('|');
      if (titleParts.length > 1) {
        document.title = `${titleParts[0].trim()} | ${settings.site_name}`;
      }
    }

    // Update footer response time text
    const footerRight = document.querySelector('.footer-right');
    if (footerRight && settings.contact_response_time) {
      footerRight.textContent = settings.contact_response_time;
    }

    // Dispatch event for any HTMX elements listening
    document.body.dispatchEvent(new CustomEvent('content-refresh-settings', {
      bubbles: true,
      detail: { settings }
    }));

    // Refresh hero section if it exists (might contain owner info)
    const heroContent = document.getElementById('hero-content');
    if (heroContent && heroContent.hasAttribute('hx-get')) {
      htmx.trigger(heroContent, 'content-refresh-settings');
    }
  }

  showUpdateToast(model, action) {
    const modelNames = {
      project: 'Project',
      post: 'Blog post',
      skill: 'Skill',
      experience: 'Experience',
      testimonial: 'Testimonial',
      settings: 'Settings'
    };

    const actionNames = {
      create: 'added',
      update: 'updated',
      destroy: 'removed',
      reorder: 'reordered'
    };

    const modelName = modelNames[model] || model;
    const actionName = actionNames[action] || action;
    const message = `${modelName} ${actionName}`;

    // Create and show toast
    const toast = document.createElement('div');
    toast.className = 'live-update-toast';
    toast.innerHTML = `
      <span class="toast-icon">✓</span>
      <span class="toast-message">${message}</span>
    `;
    
    document.body.appendChild(toast);
    
    // Animate in
    requestAnimationFrame(() => {
      toast.classList.add('visible');
    });
    
    // Remove after 3 seconds
    setTimeout(() => {
      toast.classList.remove('visible');
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }
  
  showNotification(message) {
    // Could implement a toast notification system here
    console.log('Notification:', message);
  }
}

// Initialize WebSocket for real-time updates
const portfolioWS = new PortfolioWebSocket();

// Connect when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  // Connect to WebSocket
  portfolioWS.connect();
  
  // Subscribe to content updates channel
  portfolioWS.subscribe('ContentUpdatesChannel', {}, (msg) => {
    console.log('Content update received:', msg);
  });
  
  // Subscribe to visitors channel
  portfolioWS.subscribe('VisitorsChannel', {}, (msg) => {
    console.log('Visitor update:', msg);
  });
});

// ===========================================
// Utility Functions
// ===========================================

/**
 * Smooth scroll to element
 */
function scrollToElement(selector) {
  const element = document.querySelector(selector);
  if (element) {
    element.scrollIntoView({ behavior: 'smooth' });
  }
}

/**
 * Format number with commas
 */
function formatNumber(num) {
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

/**
 * Debounce function
 */
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

/**
 * Check if element is in viewport
 */
function isInViewport(element) {
  const rect = element.getBoundingClientRect();
  return (
    rect.top >= 0 &&
    rect.left >= 0 &&
    rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
    rect.right <= (window.innerWidth || document.documentElement.clientWidth)
  );
}

// ===========================================
// Scroll Animations
// ===========================================
const observerOptions = {
  root: null,
  rootMargin: '0px',
  threshold: 0.1
};

const fadeInObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      fadeInObserver.unobserve(entry.target);
    }
  });
}, observerOptions);

// Observe elements with fade-in class
document.querySelectorAll('.fade-in').forEach(el => {
  fadeInObserver.observe(el);
});

// ===========================================
// Navbar Scroll Effect
// ===========================================
let lastScroll = 0;
const navbar = document.getElementById('navbar');

window.addEventListener('scroll', debounce(() => {
  const currentScroll = window.pageYOffset;
  
  if (currentScroll > 100) {
    navbar?.classList.add('scrolled');
  } else {
    navbar?.classList.remove('scrolled');
  }
  
  lastScroll = currentScroll;
}, 10));

// ===========================================
// Theme Detection (for future light mode)
// ===========================================
function getPreferredTheme() {
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

// Listen for theme changes
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
  // Could implement theme switching here
  console.log('Theme preference changed to:', e.matches ? 'dark' : 'light');
});

// ===========================================
// Console Easter Egg
// ===========================================
console.log(`
%c🚀 Portfolio
%cBuilt with Rails, HTMX, and lots of ☕

Interested in the code? Check out my GitHub!
`, 
'font-size: 24px; font-weight: bold; color: #dc2626;',
'font-size: 14px; color: #a3a3a3;'
);
