(function(){
var WA='https://wa.me/917387570803';
var fm=function(t){var H=Math.floor(t/60),M=t%60,s=H>=12?'PM':'AM',h=H%12||12;return h+':'+(M?'30':'00')+' '+s};
var slots=['No preference (9 AM – 8:30 PM)'];
for(var t=540;t<1230;t+=30){slots.push(fm(t)+' – '+fm(t+30))}
var opts=slots.map(function(s,i){return '<option value="'+(i?s:'')+'">'+s+'</option>'}).join('');
var el=document.createElement('div');el.className='dm';el.id='dm';el.hidden=true;el.setAttribute('role','dialog');el.setAttribute('aria-modal','true');el.setAttribute('aria-labelledby','dmt');
el.innerHTML='<div class="dm-b"><button class="dm-x" type="button" aria-label="Close">×</button><form id="dmf" novalidate><span class="dm-k">Free · 30 minutes</span><h3 id="dmt">Book a Free CRM Demo</h3><p class="dm-s">CRM Software by Drevia Infotech</p>'+
'<label class="dm-f"><span>Your name</span><input id="dn" autocomplete="name" required><em>Please enter your name.</em></label>'+
'<label class="dm-f"><span>Phone number</span><input id="dp" type="tel" inputmode="tel" autocomplete="tel" required><em>Enter a valid 10-digit phone number.</em></label>'+
'<label class="dm-f"><span>Email <small>(optional)</small></span><input id="de" type="email" autocomplete="email"></label>'+
'<label class="dm-f"><span>Preferred time <small>(optional, 9 AM – 8:30 PM)</small></span><select id="dt">'+opts+'</select></label>'+
'<button class="dm-go" type="submit">Book my free demo</button><p class="dm-n">We confirm your slot by phone or email.</p><p class="dm-n" id="dme" hidden style="color:#d92d4a">Sorry, we could not send this right now. Please call 73875 70803 or email dreviainfotech@gmail.com.</p></form>'+
'<div id="dmok" hidden><div class="dm-ck"><svg viewBox="0 0 56 56" fill="none" stroke="#22c55e" stroke-width="3" stroke-linecap="round"><circle cx="28" cy="28" r="26"/><path d="m16 29 8 8 16-18"/></svg></div><h3>Demo request sent</h3><p>Thank you. We have received your request and will confirm your slot shortly. For anything urgent, call 73875 70803.</p><button class="dm-go" type="button" id="dmc">Close</button></div></div>';
document.body.appendChild(el);
var last,product="CRM";
function open(which){product=which==="DigiClasss"?"DigiClasss":"CRM";document.getElementById("dmt").textContent="Book a Free "+product+" Demo";el.querySelector(".dm-s").textContent=product+" Software by Drevia Infotech";last=document.activeElement;el.hidden=false;document.body.style.overflow='hidden';requestAnimationFrame(function(){el.classList.add('on');document.getElementById('dn').focus({preventScroll:true})})}
function close(){el.classList.remove('on');document.body.style.overflow='';setTimeout(function(){el.hidden=true;document.getElementById('dmf').hidden=false;document.getElementById('dmok').hidden=true},300);if(last&&last.focus)last.focus()}
document.addEventListener('click',function(e){var t=e.target.closest('[data-demo]');if(t){e.preventDefault();open(t.getAttribute("data-demo-product"))}if(e.target===el||e.target.closest('.dm-x')||e.target.id==='dmc')close()});
document.addEventListener('keydown',function(e){if(e.key==='Escape'&&!el.hidden)close()});
var f=document.getElementById('dmf');
f.addEventListener('submit',function(e){e.preventDefault();var g=function(i){return document.getElementById(i).value.trim()};
 var okn=g('dn').length>1,okp=/^[+\d][\d\s-]{8,14}$/.test(g('dp'));
 document.getElementById('dn').parentNode.classList.toggle('bad',!okn);document.getElementById('dp').parentNode.classList.toggle('bad',!okp);
 if(!(okn&&okp)){document.querySelector('#dmf .bad input').focus();return}
 var data={Name:g('dn'),Phone:g('dp'),Email:g('de')||'Not given',Preferred_time:g('dt')||'Any time between 9 AM and 8:30 PM',Request:'Free '+product+' demo'};
 if(g('de'))data.email=g('de');
 var go=f.querySelector('.dm-go'),dme=document.getElementById('dme');dme.hidden=true;go.disabled=true;var tx=go.textContent;go.textContent='Sending...';
 drSend(data,'Free '+product+' demo request: '+g('dn')).then(function(){f.hidden=true;document.getElementById('dmok').hidden=false}).catch(function(){dme.hidden=false}).finally(function(){go.disabled=false;go.textContent=tx})
});
if(location.hash==='#demo')setTimeout(function(){open('CRM')},3500);
})();
