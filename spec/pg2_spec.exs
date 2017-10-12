defmodule Pg2Spec do
  use ESpec

  before do: {:shared, group_name: make_ref()}
  finally do: :pg2.delete(shared.group_name)

  describe "differences from :pg2" do
    context "get_closest_pid/1" do
      it "returns {:error, {:no_process, group_name}} when the group does not exist" do
        expect Pg2.get_closest_pid(shared.group_name) |> to(eq {:error,{:no_process, shared.group_name}})
      end
    end
    context "get_local_members/1" do
      it "returns [] when the group does not exist" do
        expect Pg2.get_local_members(shared.group_name) |> to(eq [])
      end
    end
    context "get_members/1" do
      it "returns [] when the group does not exist" do
        expect Pg2.get_members(shared.group_name) |> to(eq [])
      end
    end
    context "join/2" do
      it "creates the group if it doesn't exist" do
        Pg2.join(shared.group_name, self())
        expect :pg2.get_members(shared.group_name) |> to(eq [self()])
      end
      it "defaults to self() for pid" do
        Pg2.join(shared.group_name)
        expect :pg2.get_members(shared.group_name) |> to(eq [self()])
      end
    end
    context "leave/2" do
      it "returns :ok if the group does not exist" do
        expect Pg2.leave(shared.group_name, self()) |> to(eq :ok)
      end
      it "defaults to self() for pid" do
        expect Pg2.leave(shared.group_name) |> to(eq :ok)
      end
      it "deletes the group if it has no members" do
        Pg2.join(shared.group_name)
        Pg2.leave(shared.group_name)
        expect :pg2.which_groups |> to(eq [])
      end
    end
  end

  describe "retained functionality" do
    specify "other pids for leave and join can still be provided" do
      pid = Process.spawn(fn -> Process.sleep(100) end, [])
      expect Pg2.join(shared.group_name, pid)    |> to(eq :ok)
      expect Pg2.get_members(shared.group_name) |> to(eq [pid])
      expect Pg2.leave(shared.group_name, pid)   |> to(eq :ok)
      expect Pg2.get_members(shared.group_name) |> to(eq [])
    end
  end
end
