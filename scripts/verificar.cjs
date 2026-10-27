const { chromium } = require(process.env.PLAYWRIGHT_PATH || 'playwright');
const fs = require('node:fs');
const assert = require('node:assert/strict');
(async () => {
 const browser = await chromium.launch({channel:'chrome',headless:true});
 try {
  const page = await browser.newPage({viewport:{width:1440,height:940}});
  const errors=[]; page.on('pageerror', e=>errors.push(e.message));
  const response=await page.goto('http://localhost:8088/taller-s12s23/lista_empleados.xhtml');
  assert.equal(response.status(),200);
  assert.equal(await page.locator('tbody tr').count(),5);
  assert.equal(await page.locator('#activos').innerText(),'3');
  assert.equal(await page.locator('.active').count(),3);
  assert.equal(await page.locator('.inactive').count(),2);
  await page.screenshot({path:'evidencias/01-listado.png',fullPage:true});
  await page.getByRole('button',{name:'Desactivar',exact:true}).first().click();
  await page.waitForFunction(()=>document.querySelector('#activos').textContent==='2');
  await page.getByRole('button',{name:'Desactivar',exact:true}).first().click();
  await page.waitForFunction(()=>document.querySelector('#activos').textContent==='1');
  assert.equal(await page.locator('.inactive').count(),4);
  await page.screenshot({path:'evidencias/02-estado-conservado.png',fullPage:true});
  await page.getByRole('button',{name:'Vaciar lista'}).click();
  await page.getByText('No hay empleados registrados',{exact:true}).waitFor();
  assert.equal(await page.locator('#total').innerText(),'0');
  assert.equal(await page.locator('table').count(),0);
  await page.screenshot({path:'evidencias/03-lista-vacia.png',fullPage:true});
  await page.getByRole('button',{name:'Restaurar datos'}).click();
  await page.waitForFunction(()=>document.querySelector('#total').textContent==='5');
  assert.equal(await page.locator('#activos').innerText(),'3');
  await page.setViewportSize({width:390,height:844});
  await page.screenshot({path:'evidencias/04-movil.png',fullPage:true});
  assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));
  assert.deepEqual(errors,[]);
  // Evidencia combinada: captura real del navegador y fuente original, sin modificar la aplicación.
  const shot=fs.readFileSync('evidencias/01-listado.png').toString('base64');
  const source=fs.readFileSync('src/main/webapp/lista_empleados.xhtml','utf8');
  const esc=s=>s.replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;');
  await page.setViewportSize({width:2000,height:1100});
  await page.setContent('<html><meta charset="utf-8"><body style="margin:0;background:#132a43;color:white;font:16px Segoe UI"><h2 style="padding:12px">Evidencia · ejecución en Tomcat y código fuente XHTML</h2><div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;padding:20px"><div><p>http://localhost:8088/taller-s12s23/lista_empleados.xhtml</p><img style="width:100%" src="data:image/png;base64,'+shot+'"/></div><div><p>src/main/webapp/lista_empleados.xhtml (archivo original)</p><pre style="white-space:pre-wrap;overflow-wrap:anywhere;background:#0c1d30;padding:20px;font:12px Consolas">'+esc(source)+'</pre></div></div></body></html>');
  await page.screenshot({path:'evidencias/05-ejecucion-y-codigo.png',fullPage:true});
  const result={resultado:'OK',http:200,registros:5,activosIniciales:3,inactivosIniciales:2,estadoPreservadoEnDosPostbacks:true,listaVacia:true,restauracion:true,responsive:true,erroresJavaScript:errors};
  fs.writeFileSync('evidencias/resultado-pruebas.json',JSON.stringify(result,null,2)); console.log(result);
 } finally {await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1;});
