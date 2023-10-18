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

The implementation of "Anti Data-Loss Proposital" on the client side is a security measure designed to prevent accidental data loss. In certain situations, like attempting to pass parameters that could result in data loss (e.g., "nan" or utf8 with a length of "nil"), the module ensures safe handling to maintain data integrity and game stability.

It's important to note that while this implementation enhances security, it's not a foolproof solution. Each game is unique with specific requirements and scenarios, necessitating further modifications and customizations for comprehensive security.

A recommended best practice is to implement a mechanism to detect and penalize players on the server side if such modified parameters are detected. This would indicate potential tampering with the module by an exploiter and can act as a deterrent, further enhancing the game's security.

Developers should continually review and adapt the code, staying informed about the latest security best practices and Roblox platform updates to ensure their games remain as secure as possible.

## Options

### RemotesToGUID
Setting this option to `true` will hide remotes by giving them random GUID-based names. When disabled, the names of the remotes will be invisible, which is highly recommended to prevent exploiters from identifying them through remotespy.

### StringLimiterLength
This option determines the maximum length accepted for strings. If a string exceeds this length, it will be truncated to the specified length.

### TableLimiter
When set to `true`, this option enables checking the number of tables stacked on top of each other. If the number of tables exceeds the value specified in `TableExceeded`, an empty table will be returned. This feature helps prevent server lag caused by excessive nested tables.

### TableExceeded
This option specifies the maximum allowed limit for nested tables. If the number of nested tables exceeds this limit, an empty table will be returned to maintain server performance. For example:

#### Example
Consider the following Luay table where the `TableExceeded` option is set to 5:

```lua
local TableExample = {
	a = {
		b = {
			c = {
				d = { 
					e = {}
				}
			}
		}
	},
	
	c = {
		b = 2,
	}
}
```

In this example, the index "a" would return an empty table because it has 5 nested tables, which exceeds the specified limit of 2. However, the index "c" only has one nested table, so it would return the normal table.

## Copyright

This module is protected by copyright ©ZitDex. All rights reserved.

## License

This work is licensed under the [MIT License](https://opensource.org/licenses/MIT). See the LICENSE file for more details.