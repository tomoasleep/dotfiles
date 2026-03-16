---
name: rbs-professional
description: A skill to assist to write RBS (Ruby signature, Ruby Type system) and rbs-inline.
---

# RBS Professional

## Introductions

RBS Professional is a skill designed to assist developers in writing RBS (Ruby Signature) and rbs-inline (embedding RBS type declarations into Ruby code as comments) code.
RBS is a language for describing the types of Ruby programs, enabling better type checking and documentation.

## RBS Syntax

```
_type_ ::= _class-name_ _type-arguments_                 (Class instance type)
         | _interface-name_ _type-arguments_             (Interface type)
         | _alias-name_ _type-arguments_                 (Alias type)
         | `singleton(` _class-name_ `)`                 (Class singleton type)
         | _literal_                                     (Literal type)
         | _type_ `|` _type_                             (Union type)
         | _type_ `&` _type_                             (Intersection type)
         | _type_ `?`                                    (Optional type)
         | `{` _record-name_ `:` _type_ `,` etc. `}`     (Record type)
         | `[]` | `[` _type_ `,` etc. `]`                (Tuples)
         | _type-variable_                               (Type variables)
         | `self`
         | `instance`
         | `class`
         | `bool`
         | `untyped`
         | `nil`
         | `top`
         | `bot`
         | `void`
         | _proc_                                        (Proc type)

_class-name_ ::= _namespace_ /[A-Z]\w*/
_interface-name_ ::= _namespace_ /_[A-Z]\w*/
_alias-name_ ::= _namespace_ /[a-z]\w*/

_type-variable_ ::= /[A-Z]\w*/

_namespace_ ::=                                         (Empty namespace)
              | `::`                                    (Root)
              | _namespace_ /[A-Z]\w*/ `::`             (Namespace)

_type-arguments_ ::=                                    (No type arguments)
                   | `[` _type_ `,` etc. `]`            (Type arguments)

_literal_ ::= _string-literal_
            | _symbol-literal_
            | _integer-literal_
            | `true`
            | `false`

_proc_ ::= `^` _parameters?_ _self-type-binding?_ _block?_ `->` _type_
         | `^` `(` `?` `)` `->` _type_                                   # Proc type with untyped parameter
```

## RBS Examples

### Class instance types

```rbs
Integer                      # Instance of Integer class
::Integer                    # Instance of ::Integer class
Hash[Symbol, String]         # Instance of Hash class with type application of Symbol and String
```

### Interface types

```rbs
_ToS                          # _ToS interface
::Enumerator::_Each[String]   # Interface name with namespace and type application
```

### Alias types

The name of type aliases starts with lowercase `[a-z]`.

```rbs
name
::JSON::t                    # Alias name with namespace
list[Integer]                # Type alias can be generic
```

### Class singleton types

```rbs
singleton(String)
singleton(::Hash)            # Class singleton type cannot be parametrized.
```

### Literal types

```rbs
123                         # Integer
"hello world"               # A string
:to_s                       # A symbol
true                        # true or false
```

### Union types

```rbs
Integer | String           # Integer or String
Array[Integer | String]    # Array of Integer or String
```

### Intersection types

```rbs
_Reader & _Writer           # _Reader and _Writer
```


## rbs-inline Examples

### Method comments

```ruby
# @rbs size: Integer -- The size of the section in px
# @rbs optional: Integer -- Type of the optional parameter
# @rbs title: String -- Title of the section
# @rbs content: String -- Type of the optional keyword parameter
# @rbs *rest: String -- Type of the rest args
# @rbs **kwrest: untyped -- Type of the keyword rest args
# @rbs return: Section? -- Returns the new section or `nil`
def section(size, optional=123, title:, content: "Hello!", *rest, **kwrest)
end

# @rbs &block: (?) -> untyped -- Block is required, but not clear what will be yielded
def foo(&block)
  yield 1
  yield 2, "true"
end

# @rbs &block: ? (?) -> untyped -- Block is optional
def bar(&block)
end

# @rbs &: (String) -> void -- It yields String
def baz
end

# @rbs *: untyped
# @rbs **: String
# @rbs &: ? (String) -> bool
def foo(*, **) = nil

# @rbs yields: String
# @rbs skip: untyped
# @rbs !return: bool
def foo(return:, yields:, skip:) #: void
end

# `# @rbs override` annotation tells the method is overriding the super class definition.

# @rbs override
def foo(x, y)
end
```

### Attributes

```ruby
class Foo
  attr_reader :name #: String
  attr_reader :size, :count #: Integer
end
```

### Instance Variables

```ruby
class Foo
  # @rbs @name: String -- Instance variable
  # @rbs self.@all_names: Array[String] -- Instance variable of the class
end
```

### Class Definitions

#### Define Generic classes

```ruby
# @rbs generic A -- Type of `a`
# @rbs generic unchecked in B < String -- Type of `b`
class Foo
end
```

### Module Definitions

- Generics is supported with `# @rbs generic` annotation, like class definition.
- Module self type constraints can be defined with `# @rbs module-self` annotation.

```ruby
# @rbs module-self BasicObject
module Kernel
end
```

### Use Generic classes and modules

The constant super class is supported. Generics is also supported by `#[` annotation.

```ruby
class Foo < String
end

class Bar < Array #[String]
end
```

The `#[` syntax allows mixing generic modules.

```ruby
class Foo
  include Foo

  extend Enumerable #[Integer, void]
end
```

`# @rbs inherits annotation` allows specifying super class with RBS syntax, even if the super class syntax in Ruby is something unsupported.

```ruby
# @rbs inherits Hash[String, Integer]
class Foo < Hash
end

# @rbs inherits Struct[String | Integer]
class Bar < Struct.new(:size, :name, keyword_init: true)
end
```


### Blocks defining classes and modules

For method calls with blocks that defines modules/classes implicitly, we introduce `@rbs class` and `@rbs module` syntax.

The `@rbs module` and `@rbs class` annotations accepts RBS syntax for opening modules/classes. end is omitted.

```ruby
module Foo
  extend ActiveSupport::Concern

  # @rbs module ClassMethods
  class_methods do
    # @rbs () -> Integer
    def foo = 123
  end
end
```

### Constant Types

```ruby
VERSION = "1.2.3"

Foo = [1,2,3].sample #: Integer
```

### Embedding RBS elements directory

We have `# @rbs!` annotation for something not covered by the annotations.

```ruby
class Person
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer, default: 0
  attribute :name, :string, default: ''

  # @rbs!
  #   attr_accessor id (): Integer
  #
  #   attr_accessor name (): String
end
```

## References

- https://github.com/ruby/rbs/blob/master/docs/syntax.md
- https://github.com/ruby/rbs/blob/master/docs/rbs_by_example.md
- https://github.com/soutaro/rbs-inline/wiki/Syntax-guide
