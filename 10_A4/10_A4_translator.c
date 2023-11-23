
typedef enum Type{
    INT,
    FLOAT,
    BOOL,
    STRING,
    VOID,
    ARRAY,
    FUNCTION,
    STRUCT,
    STRUCT_ARRAY
}Type;

typedef struct Entry{
    char *name;
    Type type;
    int value;
    int size;
    int offset;
    struct Entry *nestedTable;
}Entry;

typedef struct SymbolTable{
    char *name;
    struct Entry *entry;
}SymbolTable;


Entry *create_entry(char *name, Type type, int initial_value, int size, int offset, Entry *nested_table) {
  Entry *entry = malloc(sizeof(Entry));
  entry->name = strdup(name);
  entry->type = type;
  entry->initial_value = initial_value;
  entry->size = size;
  entry->offset = offset;
  entry->nested_table = nested_table;
  return entry;
}

SymbolTable *create_symbol_table(char *name) {
  SymbolTable *table = malloc(sizeof(SymbolTable));
  table->name = strdup(name);
  table->entries = NULL;
  return table;
}

void add_entry(SymbolTable *table, Entry *entry) {
  entry->next = table->entries;
  table->entries = entry;
}

Entry *get_entry(SymbolTable *table, char *name) {
  Entry *entry = table->entries;
  while (entry != NULL) {
    if (strcmp(entry->name, name) == 0) {
      return entry;
    }
    entry = entry->next;
  }
  return NULL;
}

void print_symbol_table(SymbolTable *table) {
  printf("Name\tType\tInitial Value\tSize\tOffset\tNested Table\n");
  printf("----\t----\t--------------\t----\t----\t------------\n");
  Entry *entry = table->entries;
  while (entry != NULL) {
    printf("%s\t%s\t%d\t%d\t%d\t%s\n",
           entry->name,
           type_to_string(entry->type),
           entry->initial_value,
           entry->size,
           entry->offset,
           (entry->nested_table != NULL) ? "Yes" : "No");
    entry = entry->next;
  }
}

char *type_to_string(Type type) {
  switch (type) {
    case TYPE_INT:
      return "int";
    case TYPE_CHAR:
      return "char";
    case TYPE_ARRAY:
      return "array";
    case TYPE_POINTER:
      return "pointer";
    case TYPE_FUNCTION:
      return "function";
    default:
      return "unknown";
  }
}