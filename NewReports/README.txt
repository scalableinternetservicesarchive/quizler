This folder tries to gather all the tsung load tests by type of test instead of by date.
3 subfolders depending on the type of tsung flow we used.

- Old-flow folder corresponds to the initial tsung flow where we sign in all the time and didn't really think about
good flows.

- old-flow-modified is the same as old-flow but we realized that we should not sign in when we play a quiz so we removed
the sign in. However we still have non realistic sessions in this flow.

- newFlow contains 3 realistics flows that could be used by real users. The sign in also doesn't exist when we play a quiz.
And some actions related to find a friend or add a friend or see my friend requests have been merged together in a unique
session.

- before-pagination is reports from the stage before pagination was implemented

- master, reports from load test on master (SQL optimization and pagination) (Date: Dec 7 2015)

- with-pagination, reports from load test after we implemented pagination (without SQL optimization) 


Also for the tests with 1 instance. Sometimes we recorded 7 phases and sometimes we recorded 8 phases because we noticed that
the graphs were unreadable with 8 phases.

In newFlow and oldFlow folders, there are caching folders. But there are 2 types of caching folders:
caching and caching-wo-russian-doll. The first one contains the tests were we used the russian doll caching in browse
a quiz and in search users. The latter contain caching without russian doll.