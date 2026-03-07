/* ════════════════════════════════════════════════
   DATA
   ════════════════════════════════════════════════ */

const SUBSTANCES = {

  mdma: {
    id: 'mdma',
    name: 'MDMA',
    emoji: '💜',
    aka: 'Ecstasy · Molly · Pills',
    accent: '#A855F7',
    accentBg: 'rgba(168, 85, 247, 0.08)',
    phases: {
      before: {
        id: 'before',
        label: 'Before',
        timing: '1–2 hours before dosing',
        timingIcon: '⏱',
        alert: null,
        supplements: [
          {
            id: 'mdma-before-magnesium',
            name: 'Magnesium Glycinate',
            dose: '200mg',
            essential: true,
            reason: 'Reduces jaw clenching (bruxism)',
            note: null
          },
          {
            id: 'mdma-before-vitc',
            name: 'Vitamin C',
            dose: '1000mg',
            essential: true,
            reason: 'Antioxidant — helps protect neurons',
            note: null
          },
          {
            id: 'mdma-before-ala',
            name: 'Alpha Lipoic Acid',
            dose: '100mg',
            essential: false,
            reason: 'Powerful antioxidant — reduces neurotoxicity risk',
            note: 'R-ALA preferred if available'
          },
          {
            id: 'mdma-before-egcg',
            name: 'EGCG (Green Tea Extract)',
            dose: '400mg',
            essential: false,
            reason: 'MAO-B inhibitor — further reduces neurotoxicity',
            note: null
          }
        ]
      },
      during: {
        id: 'during',
        label: 'During',
        timing: 'Every 2 hours while rolling',
        timingIcon: '🔄',
        alert: null,
        supplements: [
          {
            id: 'mdma-during-vitc',
            name: 'Vitamin C',
            dose: '250mg',
            essential: true,
            reason: 'Ongoing antioxidant protection throughout the experience',
            note: null
          },
          {
            id: 'mdma-during-magnesium',
            name: 'Magnesium',
            dose: '100mg',
            essential: false,
            reason: 'Take more if jaw clenching is still happening',
            note: 'Only take if you need it'
          }
        ]
      },
      after: {
        id: 'after',
        label: 'After',
        timing: 'Next day — wait 24h+ after MDMA',
        timingIcon: '🌅',
        alert: {
          type: 'warning',
          icon: '⚠️',
          title: 'Wait 24+ hours before taking 5-HTP',
          body: 'Taking 5-HTP too soon after MDMA risks serotonin syndrome. It must be at least 24 hours after your last dose.'
        },
        supplements: [
          {
            id: 'mdma-after-5htp',
            name: '5-HTP',
            dose: '100mg',
            essential: true,
            reason: 'Helps restore depleted serotonin — the main recovery supplement',
            note: null
          },
          {
            id: 'mdma-after-vitc',
            name: 'Vitamin C',
            dose: '1000mg',
            essential: true,
            reason: 'Continued antioxidant recovery support',
            note: null
          },
          {
            id: 'mdma-after-nac',
            name: 'NAC',
            dose: '600mg',
            essential: false,
            reason: 'Glutathione precursor — general recovery support',
            note: null
          },
          {
            id: 'mdma-after-melatonin',
            name: 'Melatonin',
            dose: '1–3mg',
            essential: false,
            reason: 'Sleep aid — MDMA disrupts sleep significantly',
            note: 'Take at bedtime. Start with a low dose.'
          }
        ]
      }
    }
  },

  lsd: {
    id: 'lsd',
    name: 'LSD',
    emoji: '⚡',
    aka: 'Acid · Tabs · Blotter',
    accent: '#3B82F6',
    accentBg: 'rgba(59, 130, 246, 0.08)',
    phases: {
      before: {
        id: 'before',
        label: 'Before',
        timing: '1–2 hours before dosing',
        timingIcon: '⏱',
        alert: null,
        supplements: [
          {
            id: 'lsd-before-magnesium',
            name: 'Magnesium Glycinate',
            dose: '400mg',
            essential: true,
            reason: 'Reduces anxiety and muscle tension during the trip',
            note: null
          },
          {
            id: 'lsd-before-vitc',
            name: 'Vitamin C',
            dose: '1000mg',
            essential: true,
            reason: 'May ease intensity and reduce anxiety',
            note: null
          }
        ]
      },
      during: {
        id: 'during',
        label: 'During',
        timing: 'As needed during the trip',
        timingIcon: '💊',
        alert: null,
        supplements: [
          {
            id: 'lsd-during-vitc',
            name: 'Vitamin C',
            dose: '1000–3000mg',
            essential: false,
            reason: 'Can help reduce intensity if you feel overwhelmed',
            note: 'Widely reported by users. Not guaranteed but commonly used as a "come down" tool.'
          },
          {
            id: 'lsd-during-magnesium',
            name: 'Magnesium',
            dose: '200mg',
            essential: false,
            reason: 'If anxiety or muscle tension becomes uncomfortable',
            note: 'Take only if you need it'
          }
        ]
      },
      after: {
        id: 'after',
        label: 'After',
        timing: 'After the experience ends',
        timingIcon: '🌅',
        alert: null,
        supplements: [
          {
            id: 'lsd-after-magnesium',
            name: 'Magnesium Glycinate',
            dose: '400mg',
            essential: true,
            reason: 'Recovery, muscle relaxation, and coming down',
            note: null
          },
          {
            id: 'lsd-after-melatonin',
            name: 'Melatonin',
            dose: '0.5–3mg',
            essential: false,
            reason: 'Sleep support — LSD delays sleep significantly',
            note: 'Take when you feel ready for sleep. Start low (0.5mg).'
          }
        ]
      }
    }
  },

  shrooms: {
    id: 'shrooms',
    name: 'Psilocybin',
    emoji: '🍄',
    aka: 'Mushrooms · Shrooms',
    accent: '#22C55E',
    accentBg: 'rgba(34, 197, 94, 0.08)',
    phases: {
      before: {
        id: 'before',
        label: 'Before',
        timing: '30–60 min before dosing',
        timingIcon: '⏱',
        alert: null,
        supplements: [
          {
            id: 'shrooms-before-ginger',
            name: 'Ginger',
            dose: '500mg capsule or tea',
            essential: true,
            reason: 'Reduces nausea — very common with mushrooms',
            note: 'Ginger tea works too. Keep some nearby during the trip.'
          },
          {
            id: 'shrooms-before-magnesium',
            name: 'Magnesium Glycinate',
            dose: '400mg',
            essential: true,
            reason: 'Reduces body load — helps with vasoconstriction and muscle tension',
            note: null
          },
          {
            id: 'shrooms-before-vitc',
            name: 'Vitamin C',
            dose: '1000mg',
            essential: false,
            reason: 'General antioxidant and immune support',
            note: null
          }
        ]
      },
      during: {
        id: 'during',
        label: 'During',
        timing: 'As needed during the trip',
        timingIcon: '💊',
        alert: null,
        supplements: [
          {
            id: 'shrooms-during-ginger',
            name: 'Ginger',
            dose: '500mg or sip tea',
            essential: true,
            reason: 'Ongoing nausea relief if you feel sick',
            note: 'Sipping ginger tea slowly is very effective'
          }
        ]
      },
      after: {
        id: 'after',
        label: 'After',
        timing: 'After the experience ends',
        timingIcon: '🌅',
        alert: null,
        supplements: [
          {
            id: 'shrooms-after-magnesium',
            name: 'Magnesium Glycinate',
            dose: '400mg',
            essential: true,
            reason: 'Recovery, relaxation, and easing residual body tension',
            note: null
          },
          {
            id: 'shrooms-after-melatonin',
            name: 'Melatonin',
            dose: '0.5–3mg',
            essential: false,
            reason: 'Sleep support if you have trouble winding down',
            note: 'Shrooms usually allow sleep easier than LSD, but can help'
          }
        ]
      }
    }
  },

  ketamine: {
    id: 'ketamine',
    name: 'Ketamine',
    emoji: '🔷',
    aka: 'K · Special K · Ket',
    accent: '#06B6D4',
    accentBg: 'rgba(6, 182, 212, 0.08)',
    phases: {
      before: {
        id: 'before',
        label: 'Before',
        timing: '1–2 hours before',
        timingIcon: '⏱',
        alert: {
          type: 'info',
          icon: 'ℹ️',
          title: 'Bladder protection is critical',
          body: 'Ketamine can cause serious, irreversible bladder damage with repeated use. NAC and Vitamin C are the most important harm reduction steps you can take.'
        },
        supplements: [
          {
            id: 'ket-before-nac',
            name: 'NAC (N-Acetyl Cysteine)',
            dose: '600mg',
            essential: true,
            reason: 'Bladder protection — the single most important supplement for ketamine use',
            note: 'Do not skip this. Take before every session.'
          },
          {
            id: 'ket-before-vitc',
            name: 'Vitamin C',
            dose: '1000mg',
            essential: true,
            reason: 'Bladder and tissue protection — works alongside NAC',
            note: null
          }
        ]
      },
      during: {
        id: 'during',
        label: 'During',
        timing: null,
        timingIcon: null,
        alert: null,
        supplements: []
      },
      after: {
        id: 'after',
        label: 'After',
        timing: 'After the experience',
        timingIcon: '🌅',
        alert: null,
        supplements: [
          {
            id: 'ket-after-nac',
            name: 'NAC (N-Acetyl Cysteine)',
            dose: '600mg',
            essential: true,
            reason: 'Bladder protection — take again after every session',
            note: 'Critical. Take every single time you use ketamine.'
          },
          {
            id: 'ket-after-vitc',
            name: 'Vitamin C',
            dose: '1000mg',
            essential: true,
            reason: 'Continued bladder and tissue protection',
            note: null
          },
          {
            id: 'ket-after-magnesium',
            name: 'Magnesium Glycinate',
            dose: '400mg',
            essential: false,
            reason: 'Muscle relaxation and general recovery',
            note: null
          }
        ]
      }
    }
  }
};

/* ════════════════════════════════════════════════
   STATE & STORAGE
   ════════════════════════════════════════════════ */

const STORAGE_KEY = 'harm-reduction-v1';
const EXPIRY_MS = 48 * 60 * 60 * 1000; // 48 hours

let state = {
  screen: 'home',       // 'home' | 'substance'
  substanceId: null,    // 'mdma' | 'lsd' | 'shrooms' | 'ketamine'
  phase: 'before',      // 'before' | 'during' | 'after'
  checked: new Set(),   // set of supplement IDs
  savedAt: null
};

function loadState() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return;
    const data = JSON.parse(raw);
    const age = Date.now() - (data.savedAt || 0);
    if (age < EXPIRY_MS) {
      state.checked = new Set(data.checked || []);
      state.savedAt = data.savedAt;
    }
  } catch (_) { /* ignore */ }
}

function saveState() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify({
      checked: [...state.checked],
      savedAt: state.savedAt || Date.now()
    }));
  } catch (_) { /* ignore */ }
}

/* ════════════════════════════════════════════════
   ACTIONS
   ════════════════════════════════════════════════ */

function toggleCheck(id) {
  if (state.checked.has(id)) {
    state.checked.delete(id);
  } else {
    state.checked.add(id);
    if (!state.savedAt) state.savedAt = Date.now();
  }
  saveState();
  renderSupplementCardUpdate(id);
  updatePhaseTabs();
  updateProgressNote();
}

function resetChecks() {
  const substance = SUBSTANCES[state.substanceId];
  if (!substance) return;
  for (const phase of Object.values(substance.phases)) {
    for (const s of phase.supplements) {
      state.checked.delete(s.id);
    }
  }
  saveState();
  render();
}

function goHome() {
  state.screen = 'home';
  state.substanceId = null;
  state.phase = 'before';
  history.replaceState({ screen: 'home' }, '');
  render();
  window.scrollTo(0, 0);
}

function goSubstance(id) {
  state.screen = 'substance';
  state.substanceId = id;
  state.phase = 'before';
  history.pushState({ screen: 'substance', id }, '');
  render();
  window.scrollTo(0, 0);
}

function setPhase(phase) {
  if (state.phase === phase) return;
  state.phase = phase;
  renderPhaseArea();
  updatePhaseTabs();
  // Scroll phase tabs into view smoothly
  const tabs = document.querySelector('.phase-tabs');
  if (tabs) tabs.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

/* ════════════════════════════════════════════════
   PARTIAL DOM UPDATES (for performance on low-end devices)
   ════════════════════════════════════════════════ */

// Toggle checked state on a single card without full re-render
function renderSupplementCardUpdate(id) {
  const card = document.querySelector(`.supplement-card[data-id="${CSS.escape(id)}"]`);
  if (!card) return;
  if (state.checked.has(id)) {
    card.classList.add('is-checked');
  } else {
    card.classList.remove('is-checked');
  }
}

function updatePhaseTabs() {
  const substance = SUBSTANCES[state.substanceId];
  if (!substance) return;
  ['before', 'during', 'after'].forEach(p => {
    const tab = document.querySelector(`.phase-tab[data-phase="${p}"]`);
    if (!tab) return;
    const { checked, total } = phaseCheckCount(substance.id, p);
    const countEl = tab.querySelector('.phase-tab-count');
    if (countEl) countEl.textContent = total > 0 ? `${checked}/${total}` : '—';
    tab.classList.toggle('active', p === state.phase);
  });
}

function updateProgressNote() {
  const el = document.querySelector('.progress-note');
  if (!el) return;
  const substance = SUBSTANCES[state.substanceId];
  if (!substance) return;
  const { checked, total } = totalCheckCount(substance.id);
  el.textContent = checked > 0 ? `${checked} of ${total} checked across all phases` : '';
}

function renderPhaseArea() {
  const area = document.getElementById('phase-area');
  if (!area) return;
  const substance = SUBSTANCES[state.substanceId];
  if (!substance) return;
  area.innerHTML = buildPhaseArea(substance);
}

/* ════════════════════════════════════════════════
   COUNTS
   ════════════════════════════════════════════════ */

function phaseCheckCount(substanceId, phaseId) {
  const phase = SUBSTANCES[substanceId]?.phases[phaseId];
  if (!phase) return { checked: 0, total: 0 };
  return {
    checked: phase.supplements.filter(s => state.checked.has(s.id)).length,
    total: phase.supplements.length
  };
}

function totalCheckCount(substanceId) {
  const substance = SUBSTANCES[substanceId];
  if (!substance) return { checked: 0, total: 0 };
  let checked = 0, total = 0;
  for (const phase of Object.values(substance.phases)) {
    total += phase.supplements.length;
    checked += phase.supplements.filter(s => state.checked.has(s.id)).length;
  }
  return { checked, total };
}

/* ════════════════════════════════════════════════
   RENDER HELPERS
   ════════════════════════════════════════════════ */

function buildCheckSVG() {
  return `<svg class="check-svg" viewBox="0 0 15 15" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M2.5 7.5L6 11L12.5 4" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
  </svg>`;
}

function buildSupplementCard(s) {
  const checked = state.checked.has(s.id);
  return `
    <button class="supplement-card${checked ? ' is-checked' : ''}" data-id="${s.id}" onclick="toggleCheck('${s.id}')">
      <div class="supplement-inner">
        <div class="checkbox-wrap">
          <div class="checkbox-visual">${buildCheckSVG()}</div>
        </div>
        <div class="supplement-info">
          <div class="supplement-top">
            <span class="supplement-name">${s.name}</span>
            <span class="supplement-dose">${s.dose}</span>
            ${s.essential ? '<span class="badge-essential">Essential</span>' : ''}
          </div>
          <p class="supplement-reason">${s.reason}</p>
          ${s.note ? `<p class="supplement-note">${s.note}</p>` : ''}
        </div>
      </div>
    </button>`;
}

function buildSupplementList(phase) {
  if (phase.supplements.length === 0) {
    return `
      <div class="empty-phase">
        <span class="empty-phase-icon">✌️</span>
        <div class="empty-phase-title">Nothing to take during</div>
        <p class="empty-phase-body">No supplements needed during the experience.<br>Stay hydrated — but don't overdrink.</p>
      </div>`;
  }

  const essential = phase.supplements.filter(s => s.essential);
  const optional  = phase.supplements.filter(s => !s.essential);
  const showHeadings = essential.length > 0 && optional.length > 0;

  let html = '<div class="supplement-list">';
  if (showHeadings) html += '<div class="section-heading">Essential</div>';
  html += essential.map(buildSupplementCard).join('');
  if (optional.length > 0) {
    if (showHeadings) html += '<div class="section-heading">Also helpful</div>';
    html += optional.map(buildSupplementCard).join('');
  }
  html += '</div>';
  return html;
}

function buildAlert(alert) {
  if (!alert) return '';
  return `
    <div class="alert-box ${alert.type}">
      <span class="alert-icon">${alert.icon}</span>
      <div class="alert-content">
        <span class="alert-title">${alert.title}</span>
        ${alert.body}
      </div>
    </div>`;
}

function buildPhaseArea(substance) {
  const phase = substance.phases[state.phase];
  const timingBanner = phase.timing ? `
    <div class="timing-banner">
      <span style="font-size:16px;flex-shrink:0">${phase.timingIcon}</span>
      <span class="timing-text">${phase.timing}</span>
    </div>` : '';

  return timingBanner + buildAlert(phase.alert) + buildSupplementList(phase);
}

/* ════════════════════════════════════════════════
   FULL RENDERS
   ════════════════════════════════════════════════ */

function renderHome() {
  const cards = Object.values(SUBSTANCES).map(s => `
    <button class="substance-card" data-id="${s.id}" onclick="goSubstance('${s.id}')">
      <span class="substance-emoji">${s.emoji}</span>
      <span class="substance-card-name">${s.name}</span>
      <span class="substance-card-aka">${s.aka}</span>
    </button>`).join('');

  return `
    <div class="screen">
      <div class="home-header">
        <h1 class="home-title">Harm Reduction</h1>
        <p class="home-subtitle">Know what to take before,<br>during &amp; after</p>
      </div>
      <div class="substance-grid">${cards}</div>
      <div class="home-footer">
        <p>No account needed &nbsp;·&nbsp; Everything stays on your device<br>
        Not medical advice — harm reduction information only</p>
      </div>
    </div>`;
}

function renderSubstance() {
  const substance = SUBSTANCES[state.substanceId];
  if (!substance) return renderHome();

  const tabs = ['before', 'during', 'after'].map(p => {
    const { checked, total } = phaseCheckCount(substance.id, p);
    const active = p === state.phase ? ' active' : '';
    const countStr = total > 0 ? `${checked}/${total}` : '—';
    return `
      <button class="phase-tab${active}" data-phase="${p}" onclick="setPhase('${p}')">
        ${substance.phases[p].label}
        <span class="phase-tab-count">${countStr}</span>
      </button>`;
  }).join('');

  const { checked: totalChecked, total: totalSupplements } = totalCheckCount(substance.id);
  const progressText = totalChecked > 0
    ? `${totalChecked} of ${totalSupplements} checked across all phases`
    : '';

  return `
    <div class="screen" style="--accent:${substance.accent};--accent-bg:${substance.accentBg}">
      <div class="substance-header">
        <button class="back-btn" onclick="goHome()">
          <svg width="9" height="16" viewBox="0 0 9 16" fill="none">
            <path d="M8 1L1 8L8 15" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          All substances
        </button>
        <div class="substance-title-row">
          <span class="substance-view-emoji">${substance.emoji}</span>
          <div>
            <div class="substance-view-name" style="color:${substance.accent}">${substance.name}</div>
            <div class="substance-view-aka">${substance.aka}</div>
          </div>
        </div>
      </div>

      <div class="phase-tabs">${tabs}</div>

      <div id="phase-area">${buildPhaseArea(substance)}</div>

      <div class="bottom-bar">
        <p class="progress-note">${progressText}</p>
        <button class="reset-btn" onclick="resetChecks()">Reset checkmarks</button>
      </div>
    </div>`;
}

function render() {
  document.getElementById('app').innerHTML =
    state.screen === 'home' ? renderHome() : renderSubstance();
}

/* ════════════════════════════════════════════════
   HISTORY / BACK BUTTON
   ════════════════════════════════════════════════ */

window.addEventListener('popstate', e => {
  const s = e.state;
  if (!s || s.screen === 'home') {
    state.screen = 'home';
    state.substanceId = null;
    state.phase = 'before';
  } else if (s.screen === 'substance') {
    state.screen = 'substance';
    state.substanceId = s.id;
    state.phase = 'before';
  }
  render();
  window.scrollTo(0, 0);
});

/* ════════════════════════════════════════════════
   INIT
   ════════════════════════════════════════════════ */

loadState();

// Restore state from URL hash if present
history.replaceState({ screen: 'home' }, '');

render();

// Register service worker for offline support
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('./sw.js').catch(() => {});
  });
}
