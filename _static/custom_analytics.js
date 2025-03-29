// Example for Plausible Analytics
(function() {
  const script = document.createElement('script');
  script.defer = true;
  script.dataset.domain = "yourdomain.com";
  script.src = "https://plausible.io/js/script.js";
  document.head.appendChild(script);
})();

// You could add other analytics code here
// For example, tracking specific events or page views 