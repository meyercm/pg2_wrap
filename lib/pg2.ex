defmodule Pg2 do
  @moduledoc """
  A slightly opinionated wrapper around `:pg2`.  `Pg2` adds conveniences like
  automatic group creation in `join`, and returns empty lists when querying
  membership of non-existant groups.  See the documenation for each method for
  specific differences from `:pg2`
  """

  @type group_name :: any

  @doc """
  Creates a new, empty process group. The group is globally visible on
  all nodes. If the group exists, nothing happens.
  """
  @spec create(group_name) :: :ok
  def create(group_name), do: :pg2.create(group_name)

  @doc """
  Deletes a process group.
  """
  @spec delete(group_name) :: :ok
  def delete(group_name), do: :pg2.delete(group_name)

  @doc """
  A useful dispatch function that can be used from client functions. It
  returns a process on the local node, if such a process exists. Otherwise, it
  selects one randomly.

  ## Differences from :pg2
  - this function returns `{:no_process, group_name}` if the group does not
    exist, rather than `{:no_such_group, group_name}`
  """
  @spec get_closest_pid(group_name) :: :ok|{:no_process, group_name}
  def get_closest_pid(group_name) do
    case :pg2.get_closest_pid(group_name) do
      {:error, _} -> {:error, {:no_process, group_name}}
      other -> other
    end
  end

  @doc """
  Returns all processes running on the local node in the group Name. This
  function is to be used from within a client function that accesses the group.
  It is therefore optimized for speed.

  ## Differences from :pg2
  - this function returns an empty list if the group does not exist.
  """
  @spec get_local_members(group_name) :: [pid]
  def get_local_members(group_name) do
    case :pg2.get_local_members(group_name) do
      {:error, _} -> []
      other -> other
    end
  end

  @doc """

  Returns all processes in the group Name. This function is to be used from
  within a client function that accesses the group. It is therefore optimized
  for speed.

  ## Differences from :pg2
  - this function returns an empty list if the group does not exist.
  """
  @spec get_members(group_name) :: [pid]
  def get_members(group_name) do
    case :pg2.get_members(group_name) do
      {:error, _} -> []
      other -> other
    end
  end

  @doc """
  Joins the process `pid` to the group `group_name`. A process can join a group
  many times and must then leave the group the same number of times.

  ## Differences from :pg2
  - this function defaults the pid to `self()`
  - this function creates the group if it does not exist
  """
  @spec join(group_name) :: :ok
  @spec join(group_name, pid|:self) :: :ok
  def join(group_name, pid \\ :self) do
    joining_pid = case pid do
      :self -> self()
      other -> other
    end
    :pg2.create(group_name)
    :pg2.join(group_name, joining_pid)
  end

  @doc """
  Makes the process `pid` leave the group Name. If the process is not a
  member of the group, ok is returned.

  ## Differences from :pg2
  - defaults the pid to `self()`
  - returns `:ok` if the group does not exist
  """
  @spec leave(group_name) :: :ok
  @spec leave(group_name, pid|:self) :: :ok
  def leave(group_name, pid \\ :self) do
    leaving_pid = case pid do
      :self -> self()
      other -> other
    end
    case :pg2.leave(group_name, leaving_pid) do
      {:error, _} -> :ok
      other -> other
    end
  end

  @doc """
  Starts the pg2 server. Normally, the server does not need to be started
  explicitly, as it is started dynamically if it is needed. This is useful
  during development, but in a target system the server is to be started
  explicitly. Use the configuration parameters for kernel(6) for this.
  """
  @spec start() :: {:ok, pid} | {:error, any}
  def start, do: :pg2.start

  @doc """
  Starts the pg2 server. Normally, the server does not need to be started
  explicitly, as it is started dynamically if it is needed. This is useful
  during development, but in a target system the server is to be started
  explicitly. Use the configuration parameters for kernel(6) for this.
  """
  @spec start_link() :: {:ok, pid} | {:error, any}
  def start_link, do: :pg2.start_link

  @doc """
  Returns a list of all known groups.
  """
  @spec which_groups() :: [group_name]
  def which_groups, do: :pg2.which_groups


end
