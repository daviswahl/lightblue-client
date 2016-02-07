
[Lightblue]:(https://github.com/lightblue-platform)
[Arel]:(https://github.com/rails/arel)
[Data Operations]: #Data_Operations
[Query Expressions]: #Query_Expressions
[Projection Expressions]: #Projection_Expressions
[Expression Composition]: #Expression_Composition

---

NOTE:  This document serves as a specification for the intended behavior of the 1.0.0 release. We're not there yet!

---

# Lightblue::Client

Ruby query builder and client for [Lightblue][]. The focus has so far been towards taking advantage of the rich query interface provided by [Lightblue][]
1. Expressions are highly composable, which facilitates code reuse and legibility in addition to allowing queries to be built dynamically by your application.
2. Expressions are backed by an AST, which currently provides syntactic validation against the Lightblue specification, as well as decent hinting and error messaging. Long term goals here involve leveraging Lightblue's introspective capabilities (metadata, schema, etc) to provide code gen (either AOT from a local schema or dynamically by consuming metadata from a host), auto-completion, and some level of semantic validation.

[Data Operations][]

# Usage 

## Simple Queries
Expressions may be composed in a number of ways, but the simplest is to just
initialize a Lightblue Entity, which exposes methods for quickly building your 
queries.

```
    # Initialize an expression on the 1.0.0 version of `foo` schema
    foo = Lightblue.entity(:foo, '1.0.0') 
 
    # Begin a find expression within the contxt of the foo entity,
    # and bind the query and project expressions to it
    find_query = foo.find
                         .query(foo[:bar].eq(foo[:batz]))
                         .project(foo[:*])
    
    find_query.print #=>
    {
      entity: "foo",
      entityVersion: "1.0.0",
      query: { 
        field: :foo, 
        op: :$eq, 
        rfield: :bar
      },
      projection: {
        field: "*",
        include: true,
        recursive: true
      }
    }
```
Breaking down the above example:
1. We initialize a new entity named "foo", with a version string of "1.0.0"
2. We open a create a new `find` data operation on the foo entity. Operations correspond to the data APIs defined in the lightblue spec: `find`, `update`, `insert`, `save`, and `delete`. Learn more about [Data Operations][].
3. We create a query expression and bind it to the find operation. `foo[:bar]` initializes a field expression: it is shorthand for expressing 'the field `bar` on the entity `foo`". Comparison operators are defined on field expresions, so they're an important expression class.
4. We create a projection expression and bind it to the find operation. The `include` option is automatically set on projection fields, and the `recursive` field is automatically set on 
the special `*` field. To exclude a field from projection, simply negate the field: `project(![:someField])`. More on this in [Projection Expressions][].

## Entities

Currently, entities serve little semantic purpose. They simply exist to expose a number of convenience functions (such as the field operator `:[]`), and to add the `entity` and `entityVersion` fields to the data operation being performed. In future releases, entities will be capable of consuming [Lightblue][] metadata, which will expose schema specific helpers as well as perform validation against a given schema.


## Data Operations

## Expression Composition


Expressions may be composed and chained. If you are familiar with [Arel][], the syntax will look familiar:

```ruby
   foo = Lightblue.entity(:foo)
   foo = Lightblue.field(:foo)
   bar = Lightblue.field(:bar)

   foo_bar_query = foo.eq(bar)
   foo_bar_query.print 
   #=> 
   {:field=>:foo, :op=>:$eq, :rfield=>:bar}
   
   foo_in_query = foo.in(['value','another value', 'some other value'])
   foo_in_query.print 
   #=>
     { 
       field: :foo,
       op: :$in,
       values: ["value", 'another value', 'some other value']
     }
 
   foo_in_query.and(foo_bar_query).print 
   #=>
     { :$and => 
            [
              { 
                field: :foo,
                op: :$eq,
                rfield: :bar
              },
              { 
                field: :foo,
                op: :$in,
                values: ["value", 'another value', 'some other value']
              }
            ]
     }
```


Unlike [Arel][], we do not guarantee closure over all operations: Operations may 
and expressions may only be chained in a manner that makes semantic sense. However, due to the fact that an expression may be semantically valid in a 
number of contexts, some expressions are late binding, and will remain unresolved until:
1. they are bound to another expression which resolves their type, or 
2. they are implicitly bound to an expression type by calling an operator only valid on certain expressions. 

A prime example of this are array match expressions, which have different semantic meaning when bound to a query or projection. 
```
    foo = Lightblue.field(:foo)
    match_exp = foo.match(Lightblue.field[:bar].eq(1))
    match_exp.print #=> s(:match_expression, :foo, { field: :bar, op: :$eq, value: 1 })
    Lightblue.projection(match_exp).print 
    #=> 
    { 
      field: :foo, 
      match: { 
         field: :bar, 
         op: :$eq, 
         value: 1 
      }, 
      include: true, 
      recursive: false 
    }
```
For example:
Take a look at [the spec](#specs/lightblue/query_spec.rb) for better examples
https://github.com/daviswahl/lightblue-client/blob/master/spec/lightblue/query_spec.rb

TODO:

Add nodes for the rest of the tokens outlined in the spec: http://jewzaam.gitbooks.io/lightblue-specifications/content/language_specification/search_criteria.html

Add update/create/delete

See what can be done with metadata

Entities are currently arbitrary. They could be linked to a schema, although I'm not sure if it would benefit the AST.
I don't fully understand how Lightblue does field comparisons (can you compare foo_entity[:field] to bar_entity[:field] ?). Need to experiment with this and consider some kind of join syntax.
