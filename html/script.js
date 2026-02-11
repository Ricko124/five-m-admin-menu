const resourceName = typeof GetParentResourceName === 'function'
  ? GetParentResourceName()
  : 'luxuadmin';

const app = document.getElementById('app');

const post = async (name, data = {}) => {
  await fetch(`https://${resourceName}/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data)
  });
};

window.addEventListener('message', (event) => {
  const { action, visible } = event.data || {};
  if (action === 'setVisible') {
    app.classList.toggle('hidden', !visible);
  }
});

document.getElementById('closeBtn').addEventListener('click', () => post('close'));
document.getElementById('kickBtn').addEventListener('click', () => post('kickPlayer', {
  id: document.getElementById('kickId').value,
  reason: document.getElementById('kickReason').value
}));
document.getElementById('announceBtn').addEventListener('click', () => post('announce', {
  message: document.getElementById('announceMessage').value
}));
document.getElementById('weatherBtn').addEventListener('click', () => post('setWeather', {
  weather: document.getElementById('weatherType').value
}));
document.getElementById('timeBtn').addEventListener('click', () => post('setTime', {
  hour: Number(document.getElementById('timeHour').value),
  minute: Number(document.getElementById('timeMinute').value)
}));
document.getElementById('healBtn').addEventListener('click', () => post('healSelf'));
document.getElementById('reviveBtn').addEventListener('click', () => post('reviveSelf'));
document.getElementById('tpBtn').addEventListener('click', () => post('tpToWaypoint'));

document.addEventListener('keydown', (event) => {
  if (event.key === 'Escape') {
    post('close');
  }
});
