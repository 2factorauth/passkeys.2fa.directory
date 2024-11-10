export async function onRequest({env, request}) {
  const base = env.base || 'https://passkeys.2fa.directory/'
  const country = request.cf?.country.toLowerCase() || "int";
  let uri = `${base}${country}/`
  const res = await fetch(uri, {
    cf: {
      cacheTtl: 86400, cacheEverything: true
    }
  })
  if (res.status !== 200) uri = `${base}/int/`

  return Response.redirect(uri, 302);
}
