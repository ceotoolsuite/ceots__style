# CEOTS EcmaScript Style

A pure JavaScript coding style focused on readability, consistency, and simplicity.

## Syntax Rules

### Variable Declarations
- Always use `var`, never `const` or `let`
- Declare variables at the point of use, not hoisted to top

```javascript
// correct
var user_data = await fetch_user();
var result = process(user_data);

// wrong
const userData = await fetchUser();
let result = process(userData);
```

### Semicolons
- Always use semicolons, never rely on ASI (Automatic Semicolon Insertion)

```javascript
// correct
var name = 'test';
do_something();

// wrong
var name = 'test'
do_something()
```

### Trailing Commas
- Always use trailing commas in multi-line arrays and objects

```javascript
// correct
var options = {
    enabled: true,
    timeout: 5000,
};

var items = [
    'first',
    'second',
    'third',
];

// wrong
var options = {
    enabled: true,
    timeout: 5000
};
```

### Async/Await
- Always use `async/await`, never `.then()/.catch()`

```javascript
// correct
var response = await fetch(url);
var data = await response.json();

// wrong
fetch(url)
    .then(response => response.json())
    .then(data => process(data));
```

### Comments
- No comments except `// todo:` and `// note:`
- Code should be self-documenting

```javascript
// correct
// todo: add error handling
// note: a non-obvious feature of this code block is...

// wrong
// This function processes user data
// Loop through all items
```

### Code Organization
- No unnecessary blank lines
- Keep code compact
- One blank line between function definitions

## Naming Conventions

### Identifiers
- Always use `snake_case` for variables, functions, and properties
- Never use `camelCase` for your own code
- Never use hyphens in identifiers

```javascript
// correct
var user_name = 'john';
var max_retry_count = 3;
function get_user_data() {}

// wrong
var userName = 'john';
var maxRetryCount = 3;
function getUserData() {}
```

### Exceptions
- Class names use `PascalCase`
- Built-in APIs keep their original casing (`localStorage`, `getElementById`)
- External library APIs keep their original casing

```javascript
// correct
class UserManager {}
var element = document.getElementById('app');
localStorage.setItem('key', value);
```

### Namespacing
- Double underscore (`__`) for namespacing related variables
- Single underscore (`_`) for word separation within a name

```javascript
// double underscore groups related things
var poll__bar = document.querySelector('.poll-bar');
var poll__count = 0;
var poll__interval = null;

// single underscore separates words
var user_name = 'john';
var file_path = '/tmp/data';
var max_retry_count = 3;
```

## Console Logging

Use consistent patterns for scannable logs:

```javascript
// existing value - use ::
console.log('user_data :: ', user_data);

// modified value - use >>=
console.log('result >>= ', result);

// network response - use <==
console.log('response <== ', response);

// function entry - use color
console.log('%c' + 'process_data() ', 'color:yellow');

// event handler - use color
console.log('%c' + 'click handler() ', 'color:indianred');

// errors - use !!!
console.error('fetch failed !!! ', error);
```

## Quick Reference

| Rule | Correct | Wrong |
|------|---------|-------|
| Variables | `var` | `const`, `let` |
| Naming | `snake_case` | `camelCase` |
| Semicolons | Always | Optional |
| Trailing commas | Always | Optional |
| Async | `await` | `.then()` |
| Comments | `// todo:`, `// note:` only | General comments |
| Namespacing | `poll__count` | `pollCount` |
| Word separation | `user_name` | `userName` |
