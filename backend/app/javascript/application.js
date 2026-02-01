// Configure your import map in config/importmap.rb.
import "@hotwired/turbo-rails"
import "controllers"

// ===========================================
// Theme Toggle (runs immediately to prevent flash)
// ===========================================
(function initTheme() {
  const savedTheme = localStorage.getItem('portfolio-admin-theme') || 'dark';
  document.documentElement.setAttribute('data-theme', savedTheme);
})();

// Admin-specific JavaScript
document.addEventListener('turbo:load', () => {
  console.log('Admin panel loaded');
  
  // Initialize theme toggle
  initAdminThemeToggle();
  
  // Initialize sortable lists
  initSortableLists();
  
  // Initialize gradient picker
  initGradientPicker();
});

// ===========================================
// Admin Theme Toggle
// ===========================================
function initAdminThemeToggle() {
  // Inject toggle if not exists
  injectAdminThemeToggle();
  
  // Set up event listeners
  const toggleInput = document.getElementById('admin-theme-toggle-input');
  if (toggleInput) {
    const currentTheme = localStorage.getItem('portfolio-admin-theme') || 'dark';
    toggleInput.checked = currentTheme === 'light';
    
    toggleInput.addEventListener('change', () => {
      toggleAdminTheme();
    });
  }
}

function injectAdminThemeToggle() {
  // Find the sidebar header
  const sidebarHeader = document.querySelector('.sidebar-header');
  if (!sidebarHeader) return;
  
  // Check if toggle already exists
  if (document.querySelector('.admin-theme-toggle')) return;
  
  // Create toggle HTML
  const toggleHTML = `
    <div class="theme-toggle admin-theme-toggle" style="margin-left: auto;">
      <input type="checkbox" id="admin-theme-toggle-input" class="theme-toggle-input">
      <label for="admin-theme-toggle-input" class="theme-toggle-label" title="Toggle theme">
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
  
  // Insert toggle into sidebar header
  sidebarHeader.insertAdjacentHTML('beforeend', toggleHTML);
}

function toggleAdminTheme() {
  const currentTheme = document.documentElement.getAttribute('data-theme');
  const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
  
  document.documentElement.setAttribute('data-theme', newTheme);
  localStorage.setItem('portfolio-admin-theme', newTheme);
  
  // Update checkbox state
  const toggleInput = document.getElementById('admin-theme-toggle-input');
  if (toggleInput) {
    toggleInput.checked = newTheme === 'light';
  }
}

// ===========================================
// Gradient Picker
// ===========================================
function initGradientPicker() {
  const startInput = document.getElementById('project_gradient_start');
  const endInput = document.getElementById('project_gradient_end');
  const preview = document.getElementById('gradient-preview');
  
  if (!startInput || !endInput || !preview) return;
  
  const updatePreview = () => {
    preview.style.background = `linear-gradient(135deg, ${startInput.value}, ${endInput.value})`;
  };
  
  startInput.addEventListener('input', updatePreview);
  endInput.addEventListener('input', updatePreview);
  
  // Make setGradient available globally
  window.setGradient = (start, end) => {
    startInput.value = start;
    endInput.value = end;
    updatePreview();
  };
}

// ===========================================
// Sortable Lists (Drag & Drop)
// ===========================================
function initSortableLists() {
  const sortableLists = document.querySelectorAll('.skills-sortable, .sortable-list');
  
  sortableLists.forEach(list => {
    const items = list.querySelectorAll('.skill-item, .sortable-item');
    
    items.forEach(item => {
      const handle = item.querySelector('.drag-handle');
      
      // Make item draggable
      item.setAttribute('draggable', 'true');
      
      // Drag start
      item.addEventListener('dragstart', (e) => {
        item.classList.add('dragging');
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/plain', item.dataset.id);
      });
      
      // Drag end
      item.addEventListener('dragend', () => {
        item.classList.remove('dragging');
        document.querySelectorAll('.drag-over').forEach(el => el.classList.remove('drag-over'));
        
        // Save new order
        saveOrder(list);
      });
      
      // Drag over
      item.addEventListener('dragover', (e) => {
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
        
        const dragging = list.querySelector('.dragging');
        if (dragging && dragging !== item) {
          const rect = item.getBoundingClientRect();
          const midY = rect.top + rect.height / 2;
          
          if (e.clientY < midY) {
            item.parentNode.insertBefore(dragging, item);
          } else {
            item.parentNode.insertBefore(dragging, item.nextSibling);
          }
        }
      });
      
      // Drag enter/leave for visual feedback
      item.addEventListener('dragenter', (e) => {
        e.preventDefault();
        if (!item.classList.contains('dragging')) {
          item.classList.add('drag-over');
        }
      });
      
      item.addEventListener('dragleave', () => {
        item.classList.remove('drag-over');
      });
    });
  });
}

// Save the new order to the server
function saveOrder(list) {
  const items = list.querySelectorAll('.skill-item, .sortable-item');
  const order = Array.from(items).map(item => item.dataset.id);
  
  // Determine the endpoint based on the list type
  let endpoint = '/admin/skills/reorder';
  if (list.classList.contains('experiences-sortable')) {
    endpoint = '/admin/experiences/reorder';
  } else if (list.classList.contains('testimonials-sortable')) {
    endpoint = '/admin/testimonials/reorder';
  } else if (list.classList.contains('projects-sortable')) {
    endpoint = '/admin/projects/reorder';
  }
  
  // Get CSRF token
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
  
  fetch(endpoint, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': csrfToken,
      'Accept': 'application/json'
    },
    body: JSON.stringify({ order: order })
  })
  .then(response => {
    if (response.ok) {
      showToast('Order saved', 'success');
    } else {
      showToast('Failed to save order', 'error');
    }
  })
  .catch(error => {
    console.error('Error saving order:', error);
    showToast('Failed to save order', 'error');
  });
}

// Simple toast notification
function showToast(message, type = 'success') {
  const existing = document.querySelector('.admin-toast');
  if (existing) existing.remove();
  
  const toast = document.createElement('div');
  toast.className = `admin-toast ${type}`;
  toast.textContent = message;
  document.body.appendChild(toast);
  
  setTimeout(() => toast.classList.add('show'), 10);
  setTimeout(() => {
    toast.classList.remove('show');
    setTimeout(() => toast.remove(), 300);
  }, 2000);
}
