# Roblox Remote Hiding Module

This module was created to help **hide and protect remotes** in your Roblox game, providing an additional layer of security and preventing unauthorized access.

## Purpose
Remotes are a fundamental part of communication between clients and servers in Roblox games. However, it's crucial to protect and hide these remotes to prevent misuse and unauthorized access to critical game functionalities. This module offers features that help hide and manage remotes more securely, contributing to a safer and controlled gaming experience.

## Network Functions

The `RBLXNetwork` module contains specific functions to facilitate communication between clients and servers using remotes. These functions are encapsulated within the `Network` table. Below are the main functions related to remote communication:

This function is used to trigger a RemoteEvent on the server. It takes the name of the RemoteEvent to be triggered and any additional necessary arguments.

- **FireServer**:
This function is used to invoke a RemoteFunction on the server. It takes the name of the RemoteFunction to be invoked and any additional necessary arguments. It returns the result of the invocation.
  ```lua
  function Network:FireServer(RemoteName: string, ...)
  ```

- **InvokeServer**:
This function is used to invoke a RemoteFunction on the server. It takes the name of the RemoteFunction to be invoked and any additional necessary arguments. It returns the result of the invocation.
  ```lua
  function Network:InvokeServer(RemoteName: string, ...) : any
  ```

- **FireAllClients**:
This function is used to trigger a RemoteEvent on all connected clients. It takes the name of the RemoteEvent to be triggered and any additional necessary arguments.
  ```lua
  function Network:FireAllClients(RemoteName: string, ...)
  ```

- **FireClient**:
This function is used to trigger a RemoteEvent on a specific client. It takes the name of the RemoteEvent to be triggered and any additional necessary arguments.
  ```lua
  function Network:FireClient(RemoteName: string, ...)
  ```

- **CreateConnectionOf**:
This function is used to create a connection (listener) on a RemoteEvent or RemoteFunction. It takes the type of remote ("Events" or "Functions"), the name of the remote, the function to be called when the remote is triggered, and any additional necessary arguments.
  ```lua
  function Network:CreateConnectionOf(Type: string, RemoteName: string, Function: <a>(a) -> (), ...)
  ```

## Network:Init

The `Network:Init(RemoteFolder: Folder)` function is a crucial part of this module. It allows the initialization of the module, where you provide the `RemoteFolder`, a `Folder` object containing all the remotes in your game. This is essential for the module to know where to find the remotes and perform hiding and management operations.

Additionally, `Network:Init` sets up the module's context, determining whether it's running on the client or the server, to ensure the appropriate functionality is activated depending on the execution context.

## Anti Data-Loss Proposital Client

There is also an implementation of **Anti Data-Loss Proposital** on the client side. This is a security measure to prevent accidental data loss. Under certain circumstances, such as when the player attempts to pass parameters that could result in data loss, like "nan" or utf8 with a length of "nil", the module ensures that these parameters are handled safely to maintain data integrity and game stability.

## Copyright

This module is protected by copyright ©ZitDex. All rights reserved.

## License

This work is licensed under the [MIT License](https://opensource.org/licenses/MIT). See the LICENSE file for more details.
