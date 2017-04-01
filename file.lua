--
-- # file
--
-- Basic file functions for Lua.
-- can copy png kind file 

-- ## References

local io, os, error = io, os, error

-- ## file
--
-- The namespace.
--
local file = {}

-- ### file.exists
--
-- Determine if the file in the `path` exists.
--
-- - `path` is a string.
--
function file.exists(path)
  local file = io.open(path, 'rb')
  if file then
    file:close()
  end
  return file ~= nil
end

-- ### file.read
--
-- Return the content of the file by reading the given `path` and `mode`.
--
-- - `path` is a string.
-- - `mode` is a string.
--
function file.read(path, mode)
  mode = mode or '*a'
  local file, err = io.open(path, 'r+b')
  if err then
    error(err)
  end
  local content = file:read(mode)
  file:close()
  return content
end

-- ### file.write
--
-- Write to the file with the given `path`, `content` and `mode`.
--
-- - `path`    is a string.
-- - `content` is a string.
-- - `mode`    is a string.
--
function file.write(path, content, mode)
  mode = mode or 'w+b'
  local file, err = io.open(path, mode)
  if err then
    error(err)
  end
  file:write(content)
  file:close()
end

-- ### file.copy
--
-- Copy the file by reading the `src` and writing it to the `dest`.
--
-- - `src`  is a string.
-- - `dest` is a string.
--
function file.copy(src, dest)
  local content = file.read(src)
  file.write(dest, content)
end

-- ### file.move
--
-- Move the file from `src` to the `dest`.
--
-- - `src`  is a string.
-- - `dest` is a string.
--
function file.move(src, dest)
  os.rename(src, dest)
end

-- ### file.remove
--
-- Remove the file from the given `path`.
--
-- - `path` is a string.
--
function file.remove(path)
  os.remove(path)
end


-- get file in lines 
-- return table contains each lines
function file.lines(file) 
  if not file.exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

-- get all pathstring in folder 
-- need lfs
require("lfs")
function file.getpathes(rootpath, pathes,func)
    pathes = pathes or {}
    for entry in lfs.dir(rootpath) do
        if entry ~= '.' and entry ~= '..' then
            local path = rootpath .. '\\' .. entry
            local attr = lfs.attributes(path)
            assert(type(attr) == 'table')
            
            if attr.mode == 'directory' then
                getpathes(path, pathes,func)
            else
                if func then 
                   func(path)
                end 
                 
                table.insert(pathes, path)
            end
        end
    end
    return pathes
end




-- ## Exports
--
-- Export `file` as a Lua module.
--
return file
