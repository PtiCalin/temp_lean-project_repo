export function add(a, b) {
  return a + b;
}

if (import.meta.url === `file://${process.argv[1]}`) {
  console.log('Result:', add(2, 3));
}
