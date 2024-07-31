console.log('hello');

function test() {
  console.log('inside test');
  return 'world';
}

const test2 = () => {
  console.log('inside test2');
  return 'world2';
};

const result = test2();

console.log(result);
