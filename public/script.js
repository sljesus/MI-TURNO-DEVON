/* DEVON TURNOS - Client Logic (Vanilla JS) */

// Configuration (Replace with YOUR URL & Key)
const SUPABASE_URL = "https://bvrwlgxiwijytlswoucj.supabase.co";
const SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2cndsZ3hpd2lqeXRsc3dvdWNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA1ODA4MjAsImV4cCI6MjA4NjE1NjgyMH0.4cptiH7w6k3PtCD8O8SDUOcytY5nXrIdjWZjaBa22m8";

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);


let myTurnId = localStorage.getItem("devon_my_turn"); // Persist turn if refresh

// --- LOGIC ---

async function init() {
  if (myTurnId) {
    showStatusView();
  }

  // Initial Load
  await fetchQueueStatus();

  // Listen for realtime updates
  supabaseClient
    .channel('public:turns')
    .on('postgres_changes', { event: '*', schema: 'public', table: 'turns' }, payload => {
      fetchQueueStatus();
    })
    .subscribe();
}

async function joinQueue(petName, ownerName) {
  const { data, error } = await supabaseClient.rpc('fn_join_queue', {
    p_pet_name: petName,
    p_owner_name: ownerName
  });

  if (error) {
    alert("Error al unirse: " + error.message);
    return;
  }

  myTurnId = data;
  localStorage.setItem("devon_my_turn", myTurnId);
  showStatusView();
  fetchQueueStatus();
}

async function fetchQueueStatus() {
  // Get current serving
  const { data: serving } = await supabaseClient
    .from('turns')
    .select('id, pet_name')
    .eq('status', 'serving')
    .limit(1)
    .maybeSingle();

  // Get waiting list
  const { data: waiting } = await supabaseClient
    .from('turns')
    .select('id, pet_name')
    .eq('status', 'waiting')
    .order('created_at', { ascending: true })
    .limit(100); // MOSTRAR TODOS (Scroll real)

  updateUI(serving, waiting);
}

function updateUI(serving, waiting) {
  // Update Big Number
  const nowServingNum = document.getElementById("now-serving-number");
  const nowServingName = document.getElementById("now-serving-name");

  if (serving) {
    nowServingNum.textContent = serving.id;
    nowServingName.textContent = serving.pet_name;
  } else {
    nowServingNum.textContent = "--";
    nowServingName.textContent = "Nadie atendiendo";
  }

  // Update My Turn
  if (myTurnId) {
    const myTurnEl = document.getElementById("my-turn-card");
    const myTurnNumEl = document.getElementById("my-turn-number");
    const msgEl = document.getElementById("my-turn-msg");

    myTurnEl.style.display = "block";
    myTurnNumEl.textContent = myTurnId;

    if (serving && serving.id == myTurnId) {
      myTurnEl.style.backgroundColor = "#c8e6c9";
      myTurnEl.style.border = "2px solid #2e7d32";
      msgEl.textContent = "¡ES TU TURNO! PASA YA";
      msgEl.style.fontWeight = "bold";
      msgEl.style.color = "#2e7d32";
    } else {
      myTurnEl.style.backgroundColor = "#e0f7fa";
      myTurnEl.style.border = "2px solid #00acc1";
      msgEl.textContent = "Espera atento...";
      msgEl.style.color = "#006064";
    }
  }

  // Update List
  const queueList = document.getElementById("queue-list");
  queueList.innerHTML = "";
  
  if (waiting && waiting.length > 0) {
    waiting.forEach(turn => {
      const li = document.createElement("li");
      
      if (myTurnId && turn.id == myTurnId) {
        li.style.fontWeight = "bold";
        li.style.color = "#2b6cb0";
      }
      
      li.innerHTML = `<span>#${turn.id}</span> <span>${turn.pet_name}</span>`;
      queueList.appendChild(li);
    });
  } else {
    queueList.innerHTML = "<li style='color:#ccc; text-align:center'>No hay nadie esperando.</li>";
  }
}

function showStatusView() {
  const joinSection = document.getElementById("join-section");
  const listSection = document.getElementById("list-section");

  joinSection.classList.add("hidden");
  listSection.classList.remove("hidden");
  updateFooterVisibility("wait");
}

// --- EVENTS ---
const joinFormEl = document.getElementById("join-form");
if (joinFormEl) {
  joinFormEl.addEventListener("submit", (e) => {
    e.preventDefault();
    const petInput = document.getElementById("pet-name");
    const ownerInput = document.getElementById("owner-name");

    const pet = petInput ? petInput.value : null;
    const owner = ownerInput ? ownerInput.value : null;

    if (pet) joinQueue(pet, owner);
  });
}

// Help Button Logic
const helpBtn = document.getElementById("help-btn");

function updateFooterVisibility(view) {
  const footer = document.getElementById("app-footer");
  
  if (view === "join") {
    footer.style.display = "none";
  } else {
    footer.style.display = "block";
  }
}

// Inicializar oculto al principio si no hay turno
if (!myTurnId) updateFooterVisibility("join");
else updateFooterVisibility("wait");

helpBtn.addEventListener("click", () => {
  const pet = prompt("🐶 Nombre de la mascota:");
  if (!pet) return;

  const owner = prompt("👤 Nombre del dueño (Opcional):");
  joinQueueForOther(pet, owner);
});

async function joinQueueForOther(petName, ownerName) {
  const { data, error } = await supabaseClient.rpc('fn_join_queue', {
    p_pet_name: petName,
    p_owner_name: ownerName
  });

  if (error) {
    alert("Error: " + error.message);
  } else {
    alert(`✅ ¡Turno Registrado!\n\nEl turno es el: #${data} \n\nPor favor díselo a la persona.`);
  }
}

init();
