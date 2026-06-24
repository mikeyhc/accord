-record(accord_itoken, {id    :: binary(),
                        token :: binary()
                       }).

-record(accord_context, {itoken :: #accord_itoken{},
                         user   :: json(),
                         d      :: json()
                        }).

-type json() :: #{binary() => any()}.
