## "It’s not fully shipped until it’s fast." - [@tmn](https://github.com/tnm), GitHub

We want puhsh to be fast. Extra fast. That requires a level of commitment from you, the contributor, to make sure puhsh stays fast. 

This is a guideline to help you contribute to puhsh. The priority, maintained in Wunderlist, is the source of what we want to work on. Ask us for access to wunderlist.

## Rules for Contributing
1. It is not shipped / finished until it is fast. Period.
2. It is not shipped / finished until it is fast. We mean it.
3. Seriously. It is not shipped until it is fast.
4. There should always be specs for your pull requests (exceptions can be made).
5. You cannot accept your own pull request.


## Contribution Process
Puhsh contributions follow the traditional open source process.

1. Fork the repo (even if it is for small changes but exceptions can be made)
2. Make the code changes / write your specs.
3. Submit a pull request.
4. Participate in the code review process / make changes / wait for someone else to merge your changes.

## Continuous Delivery

Puhsh is built upon a continuous delivery system using Jenkins. This requires you to always be thinking about what your code changes will do to production but, at the same time, allows you move quickly. There is no backlog of items, in master, waiting to be shipped.

The work flow is as follows

1. Pull request is merged into Master.
2. Jenkins pulls down the latest code and runs the tests.
3a. If the tests all pass, Jenkins deploys to production right then and there.
 b. If the tests fail, no further builds will be deployed to production till all the specs are green again.


That sums up the contribution guide. We are all adults here, so use your best judgement if exceptions to this process occurs. Otherwise, stick to the workflow.
