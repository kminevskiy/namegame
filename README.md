### Decisions and trade-offs
  - First, I extracted API call / processing / parsing logic into separate modules - I like highly reusable / pluggable components. And even if our API changes, the only thing we'll have to change is our API adapter - everything else will be expecting the same established API contracts, which reduces refactoring.
  - Since this project is mostly back-end logic, I decided to take this whole thing one step further.
  - I thought it's a bad idea to ping our back-end API all the time - this creates unnecessary load on the back-end servers, potentially preventing our customers (if it's a public-facing API) from efficiently interacting with it.
  - To help resolve this problem, I decided to cache our user profiles in Redis. However, we don't really want to have stale or out-of-date profiles in there. That's why I set expiration of this data to 1 day (probably we are not hiring hundreds of people every hour).
  - We could take THAT one step further and cache images (that's what's taking the most time loading right now). For that I would use some CDN like Cloudflare.
  - Next, I thought it might be a good idea to track our users and their scores. And so I implemented a simple authentication system (from scratch, no external modules / libraries / gems). This will track our user accounts, their games and other statistics. Pretty cool.
  - Then, since HTTP is stateless, we probably want to track authenticated user. That's why I implemented sessions (login / logout logic). This allows us to place custom logic on certain actions (what users are authorized to do).
  - Up next we have our persistence layer. For that we have a PostgreSQL database. While storing user data in localStorage is OK, it's no fun to accidentally destroy all your games statistics with a browser crash / reset.
  - We setup every game individually with seeded data from cached API data. Did I mention that I really like the idea of not querying our back-end API server?
  - Also, because I like TDD, I wrote a few tests (around 70 right now) for some common actions. The coverage is NOT complete (far from it, in fact), but it's still better than nothing and I could catch quite a few edge cases with just these tests.
  - Application is pretty static in terms of front-end JS interactions with the user - since Rails is a full-stack framework with server-side rendering, it's pretty painful to implement something you could do with Node/Express and maybe React/Vue/Backbone. I did my best to compensate for that with fancy CSS, but, again, this is not a SPA experience.
  - There are model validations (password length, presence of first and last name, etc) in place. Thought it might be a good safety and UX thing).

Live version: https://shielded-bastion-71647.herokuapp.com


### What's working
  - User authentication
  - User sessions
  - User profiles / profile updates
  - Authorization
  - Several game modes including learning, practice, current team and ma(t|tt)
  - Caching
  - Data persistence layer
  - User statistics
  - Game statistics