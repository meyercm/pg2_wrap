# Pg2 / :pg2_wrap

## Installation

Add `{:pg2_wrap, "~> 1.0"},` to your deps list.

## Use

The `:pg2_wrap` application provides the module `Pg2`, which calls to `:pg2`
with some very slight variations to make typical uses easier.

Here it is in action:

```elixir
iex(1)> Pg2.join(:a_group)
:ok
iex(2)> Pg2.get_members(:a_group)
[#PID<0.152.0>]
iex(3)> Pg2.leave(:a_group)
:ok
iex(4)> Pg2.which_groups
[]
```

### Differences

Those familiar with :pg2 will have spotted many of the differences above. Each
method's documentation enumerates specific differences, here is the full list:

1. When calling `join` and `leave`, the pid is defaulted to `self()`
2. When calling `join` on a nonexistent group, the group is created
3. When calling `leave` on a nonexistent group, `:ok` is returned
4. When calling `get_closest_pid` of a nonexistent group, `{:error, {:no_process, group_name}}` is returned
5. When calling `get_members` and `get_local_members` of a nonexistent group, `[]` is returned
6. When calling `leave`, empty groups are deleted (after the pid is removed)
