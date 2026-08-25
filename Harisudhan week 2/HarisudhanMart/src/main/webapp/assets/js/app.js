// Shared fetch() helper. Unwraps the fixed { success, data, error } envelope
// from spec Section 13 and throws a plain Error with the server's message on failure.
async function apiFetch(url, options) {
  const opts = options || {};
  opts.headers = Object.assign({ 'Content-Type': 'application/json' }, opts.headers || {});
  const res = await fetch(url, opts);
  const body = await res.json().catch(() => null);
  if (!res.ok || (body && body.success === false)) {
    const message = body && body.error ? body.error.message : ('Request failed (' + res.status + ')');
    throw new Error(message);
  }
  return body ? body.data : null;
}

function money(value) {
  return '\u20B9' + Number(value).toFixed(2);
}
