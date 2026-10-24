(function(){
const $=(s,c=document)=>c.querySelector(s),$$=(s,c=document)=>[...c.querySelectorAll(s)];
const reduce=matchMedia('(prefers-reduced-motion:reduce)').matches;

/* split text into animated chars */
function split(el){
  const txt=el.textContent;el.setAttribute('aria-label',txt);el.textContent='';
  let k=0;
  txt.split(' ').forEach((w,wi,arr)=>{
    const wd=document.createElement('span');wd.className='wd';wd.setAttribute('aria-hidden','true');
    [...w].forEach(c=>{const s=document.createElement('span');s.className='ch';s.style.setProperty('--k',k++);s.textContent=c;wd.appendChild(s)});
    el.appendChild(wd);if(wi<arr.length-1)el.appendChild(document.createTextNode(' '));k++;
  });
}
$$('[data-split]').forEach(split);

/* LOADER */
const L=$('#loader');
const seen=sessionStorage.getItem('drv');
function finish(){
  document.body.classList.remove('loading');
  L.classList.add('go');
  setTimeout(()=>{L.remove();document.dispatchEvent(new Event('drevia:ready'))},1300);
  sessionStorage.setItem('drv','1');
}
if(L){
  document.body.classList.add('loading');
  const bar=$('.lg-bar i',L),pct=$('.lg-pct',L);
  const dur=reduce?200:(seen?1100:2900);
  const t0=performance.now();
  (function tick(n){
    const p=Math.min(1,(n-t0)/dur),e=1-Math.pow(1-p,3);
    bar.style.width=e*100+'%';pct.textContent=Math.round(e*100)+'%';
    if(p<1)requestAnimationFrame(tick);else finish();
  })(t0);
  if(seen)L.classList.add('quick');
  $$('.lg-name .ch',L).forEach(c=>c.classList.add('in'));
}else document.dispatchEvent(new Event('drevia:ready'));

/* nav */
const nav=$('.nav');
const onS=()=>{nav.classList.toggle('scrolled',scrollY>20);
  const h=document.documentElement;const p=$('.progress');if(p)p.style.width=(scrollY/(h.scrollHeight-innerHeight)*100)+'%'};
addEventListener('scroll',onS,{passive:true});onS();
const cw=$('.cta-wrap');
if(cw){$('.cta',cw).addEventListener('click',e=>{e.stopPropagation();cw.classList.toggle('open');$('.cta',cw).setAttribute('aria-expanded',cw.classList.contains('open'))});
 document.addEventListener('click',e=>{if(!cw.contains(e.target))cw.classList.remove('open')});
 addEventListener('keydown',e=>{if(e.key==='Escape')cw.classList.remove('open')});}
const bg=$('.burger'),dr=$('.drawer');
if(bg)bg.addEventListener('click',()=>{const o=dr.classList.toggle('open');bg.classList.toggle('x',o);document.body.style.overflow=o?'hidden':''});
$$('.drawer a').forEach((a,i)=>a.style.setProperty('--i',i));

/* reveal */
const io=new IntersectionObserver(es=>es.forEach(e=>{if(e.isIntersecting){e.target.classList.add('in');io.unobserve(e.target)}}),{threshold:.12,rootMargin:'0px 0px -6% 0px'});
document.addEventListener('drevia:ready',()=>{$$('[data-r],[data-split]').forEach(el=>io.observe(el))});

/* counters */
const co=new IntersectionObserver(es=>es.forEach(e=>{if(!e.isIntersecting)return;co.unobserve(e.target);
  const el=e.target,to=+el.dataset.count,s=el.dataset.suffix||'',t0=performance.now(),d=1600;
  (function f(n){const p=Math.min(1,(n-t0)/d);el.textContent=Math.round(to*(1-Math.pow(1-p,4)))+s;if(p<1)requestAnimationFrame(f)})(t0)}),{threshold:.5});
$$('[data-count]').forEach(el=>co.observe(el));

/* spotlight cards + tilt + magnetic */
document.addEventListener('pointermove',e=>{
  const g=$('#glow');if(g&&e.pointerType==='mouse'){g.style.left=e.clientX+'px';g.style.top=e.clientY+'px'}
  const s=e.target.closest&&e.target.closest('.spot');
  if(s){const r=s.getBoundingClientRect();s.style.setProperty('--mx',e.clientX-r.left+'px');s.style.setProperty('--my',e.clientY-r.top+'px')}
});
if(!reduce&&matchMedia('(hover:hover)').matches){
  $$('[data-tilt]').forEach(el=>{
    el.style.transition='transform .25s ease-out';el.style.transformStyle='preserve-3d';
    el.addEventListener('pointermove',e=>{const r=el.getBoundingClientRect(),x=(e.clientX-r.left)/r.width-.5,y=(e.clientY-r.top)/r.height-.5,m=+el.dataset.tilt||8;
      el.style.transform=`perspective(900px) rotateY(${x*m}deg) rotateX(${-y*m}deg) translateZ(0)`});
    el.addEventListener('pointerleave',()=>el.style.transform='');
  });
  $$('[data-mag]').forEach(el=>{
    el.addEventListener('pointermove',e=>{const r=el.getBoundingClientRect();el.style.transform=`translate(${(e.clientX-r.left-r.width/2)*.25}px,${(e.clientY-r.top-r.height/2)*.35}px)`});
    el.addEventListener('pointerleave',()=>el.style.transform='');
  });
}
/* parallax */
const par=$$('[data-par]');
if(par.length&&!reduce)addEventListener('scroll',()=>{par.forEach(el=>{const r=el.getBoundingClientRect();const k=+el.dataset.par;el.style.transform=`translateY(${(r.top+r.height/2-innerHeight/2)*k}px)`})},{passive:true});

/* network canvas */
window.drNet=function(cv,opt={}){
  if(!cv||reduce)return;const ctx=cv.getContext('2d');let w,h,pts=[],mx=-999,my=-999;
  const col=opt.color||'120,160,255',N=opt.n||(innerWidth<700?36:78);
  function size(){const r=cv.getBoundingClientRect();w=cv.width=r.width*devicePixelRatio;h=cv.height=r.height*devicePixelRatio;
    pts=Array.from({length:N},()=>({x:Math.random()*w,y:Math.random()*h,vx:(Math.random()-.5)*.35*devicePixelRatio,vy:(Math.random()-.5)*.35*devicePixelRatio}))}
  size();addEventListener('resize',size);
  cv.parentElement.addEventListener('pointermove',e=>{const r=cv.getBoundingClientRect();mx=(e.clientX-r.left)*devicePixelRatio;my=(e.clientY-r.top)*devicePixelRatio});
  let vis=true;new IntersectionObserver(e=>vis=e[0].isIntersecting).observe(cv);
  (function draw(){requestAnimationFrame(draw);if(!vis)return;ctx.clearRect(0,0,w,h);
    const D=150*devicePixelRatio;
    pts.forEach((p,i)=>{p.x+=p.vx;p.y+=p.vy;if(p.x<0||p.x>w)p.vx*=-1;if(p.y<0||p.y>h)p.vy*=-1;
      const dx=p.x-mx,dy=p.y-my,dm=Math.hypot(dx,dy);if(dm<180*devicePixelRatio){p.x+=dx/dm*1.4;p.y+=dy/dm*1.4}
      ctx.fillStyle=`rgba(${col},.8)`;ctx.beginPath();ctx.arc(p.x,p.y,1.6*devicePixelRatio,0,7);ctx.fill();
      for(let j=i+1;j<pts.length;j++){const q=pts[j],d=Math.hypot(p.x-q.x,p.y-q.y);if(d<D){ctx.strokeStyle=`rgba(${col},${.22*(1-d/D)})`;ctx.lineWidth=devicePixelRatio;ctx.beginPath();ctx.moveTo(p.x,p.y);ctx.lineTo(q.x,q.y);ctx.stroke()}}
      if(dm<220*devicePixelRatio){ctx.strokeStyle=`rgba(${col},${.5*(1-dm/(220*devicePixelRatio))})`;ctx.beginPath();ctx.moveTo(p.x,p.y);ctx.lineTo(mx,my);ctx.stroke()}
    });
  })();
};
})();

window.drSend=function(fields,subject){
 var d={_subject:subject,_template:'table',_captcha:'false',_cc:'parthrathi7@gmail.com',_honey:''};
 for(var k in fields)d[k]=fields[k];
 return fetch('https://formsubmit.co/ajax/dreviainfotech@gmail.com',{method:'POST',headers:{'Content-Type':'application/json','Accept':'application/json'},body:JSON.stringify(d)})
  .then(function(r){return r.json()}).then(function(j){if(j&&(j.success===true||j.success==='true'))return j;throw new Error((j&&j.message)||'send failed')});
};
