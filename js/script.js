const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');
canvas.height = window.innerHeight;
canvas.width = window.innerWidth;
let particalArray = [];
const numberOfParticales = 300;
const titleElement = document.getElementById('title');
let titleMeasurement = titleElement.getBoundingClientRect();
let title = {
  x: titleMeasurement.left,
  y: titleMeasurement.top,
  width: titleMeasurement.width,
  height: 10,
};
class Particle {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = Math.random() * 15 + 1;
    this.weight = Math.random() * 1 + 1;
    this.directionX = -1;
  }

  update() {
    if (this.y > canvas.height) {
      this.y = 0 - this.size;
      this.weight = Math.random() * 1 + 1;
      this.x = Math.random() * canvas.width * 1.5;
    }
    this.weight += 0.01;
    this.y += this.weight;
    this.x += this.directionX;
    if (
      this.x < title.x + title.width &&
      this.x + this.size > title.x &&
      this.y < title.y + title.height &&
      this.y + this.size > title.y
    ) {
      this.y -= 4;
      this.weight *= -0.5;
    }
  }

  draw() {
    ctx.fillStyle = `hsl(${this.x}, 100%, 50%)`;
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
    ctx.closePath();
    ctx.fill();
    ctx.stroke();
  }
}

function init() {
  particalArray = [];
  for (let i = 1; i < numberOfParticales; i += 1) {
    const x = Math.random() * canvas.width;
    const y = Math.random() * canvas.height;
    particalArray.push(new Particle(x, y));
  }
}
init();
function animation() {
  ctx.fillStyle = 'rgba(255,255,255,0.09)';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  particalArray.forEach((particle) => {
    particle.update();
    particle.draw();
  });
  requestAnimationFrame(animation);
}
animation();
window.addEventListener('resize', () => {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
  titleMeasurement = titleElement.getBoundingClientRect();
  title = {
    x: titleMeasurement.left,
    y: titleMeasurement.top,
    width: titleMeasurement.width,
    height: 10,
  };
  init();
});