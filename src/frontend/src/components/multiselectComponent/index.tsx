import { PopoverAnchor } from "@radix-ui/react-popover";
import Fuse from "fuse.js";
import { useEffect, useRef, useState } from "react";
import { MultiselectComponentType } from "../../types/components";
import { cn } from "../../utils/utils";
import { default as ForwardedIconComponent } from "../genericIconComponent";
import ShadTooltip from "../shadTooltipComponent";
import { Button } from "../ui/button";
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandItem,
  CommandList,
} from "../ui/command";
import {
  Popover,
  PopoverContent,
  PopoverContentWithoutPortal,
  PopoverTrigger,
} from "../ui/popover";

export default function MultiselectComponent({
  disabled,
  isLoading,
  value,
  options: defaultOptions,
  combobox,
  onSelect,
  editNode = false,
  id = "",
  children,
}: MultiselectComponentType): JSX.Element {
  const [open, setOpen] = useState(children ? true : false);

  const refButton = useRef<HTMLButtonElement>(null);

  const PopoverContentDropdown =
    children || editNode ? PopoverContent : PopoverContentWithoutPortal;

  const [customValues, setCustomValues] = useState<string[]>([]);
  const [searchValue, setSearchValue] = useState("");
  const [filteredOptions, setFilteredOptions] = useState(defaultOptions);
  const [onlySelected, setOnlySelected] = useState(false);

  const [options, setOptions] = useState<string[]>(defaultOptions);

  const fuseOptions = new Fuse(options, { keys: ["name", "value"] });
  const fuseValues = new Fuse(value, { keys: ["name", "value"] });

  const searchRoleByTerm = async (v: string) => {
    const fuse = onlySelected ? fuseValues : fuseOptions;
    const searchValues = fuse.search(v);
    let filtered: string[] = searchValues.map((search) => search.item);
    if (!filtered.includes(v) && combobox && v) filtered = [v, ...filtered];
    setFilteredOptions(
      v
        ? filtered
        : onlySelected
          ? options.filter((x) => value.includes(x))
          : options,
    );
  };

  useEffect(() => {
    if (disabled && value.length > 0 && value[0] !== "") {
      onSelect([], undefined, true);
    }
  }, [disabled]);

  useEffect(() => {
    searchRoleByTerm(searchValue);
  }, [onlySelected]);

  useEffect(() => {
    searchRoleByTerm(searchValue);
  }, [options]);

  useEffect(() => {
    setCustomValues(value.filter((v) => !defaultOptions.includes(v)) ?? []);
    setOptions([
      ...value.filter((v) => !defaultOptions.includes(v) && v),
      ...defaultOptions,
    ]);
  }, [value]);

  useEffect(() => {
    if (open) {
      setOnlySelected(false);
      setSearchValue("");
      searchRoleByTerm("");
    }
  }, [open]);

  const handleOptionSelect = (currentValue) => {
    if (value.includes(currentValue)) {
      onSelect(value.filter((v) => v !== currentValue));
    } else {
      onSelect([...value, currentValue]);
    }
  };

  const renderDropdownTrigger = () => (
    <PopoverTrigger asChild>
      <Button
        disabled={disabled}
        variant="primary"
        size="xs"
        role="combobox"
        ref={refButton}
        aria-expanded={open}
        data-testid={id}
        className={cn(
          editNode
            ? "dropdown-component-outline input-edit-node"
            : "dropdown-component-false-outline py-2",
          "w-full justify-between font-normal",
        )}
      >
        <span className="truncate" data-testid={`value-dropdown-${id}`}>
          {value.length > 0 && options.find((option) => value.includes(option))
            ? value.join(", ")
            : "Choose an option..."}
        </span>
        <ForwardedIconComponent
          name="ChevronsUpDown"
          className="ml-2 h-4 w-4 shrink-0 opacity-50"
        />
      </Button>
    </PopoverTrigger>
  );

  const renderSearchInput = () => (
    <div className="flex items-center border-b px-3">
      <ForwardedIconComponent
        name="search"
        className="mr-2 h-4 w-4 shrink-0 opacity-50"
      />
      <input
        onChange={(event) => {
          setSearchValue(event.target.value);
        }}
        placeholder="Search options..."
        className="flex h-9 w-full rounded-md bg-transparent py-3 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50"
      />
      <Button
        unstyled
        className="ml-2"
        onClick={() => setOnlySelected((old) => !old)}
      >
        <ForwardedIconComponent
          className="h-4 w-4"
          name={onlySelected ? "CheckCheck" : "Check"}
        />
      </Button>
    </div>
  );

  const renderOptionsList = () => (
    <CommandList className="overflow-y-scroll">
      <CommandEmpty>No values found.</CommandEmpty>
      <CommandGroup>
        {filteredOptions.map((option, index) => (
          <ShadTooltip key={index} delayDuration={700} content={option}>
            <div>
              <CommandItem
                value={option}
                onSelect={handleOptionSelect}
                className="items-center overflow-hidden truncate"
                data-testid={`${option}-${id ?? ""}-option`}
              >
                {(customValues.includes(option) || searchValue === option) && (
                  <span className="text-muted-foreground">Text:&nbsp;</span>
                )}
                <span className="truncate">{option}</span>
                <ForwardedIconComponent
                  name="Check"
                  className={cn(
                    "ml-auto h-4 w-4 shrink-0 text-primary",
                    value.includes(option) ? "opacity-100" : "opacity-0",
                  )}
                />
              </CommandItem>
            </div>
          </ShadTooltip>
        ))}
      </CommandGroup>
    </CommandList>
  );

  if (Object.keys(options).length === 0 && !combobox) {
    return isLoading ? (
      <div>
        <span className="text-sm italic">Loading...</span>
      </div>
    ) : (
      <div>
        <span className="text-sm italic">
          No parameters are available for display.
        </span>
      </div>
    );
  }

  return (
    <Popover open={open} onOpenChange={children ? () => {} : setOpen}>
      {children ? (
        <PopoverAnchor>{children}</PopoverAnchor>
      ) : (
        renderDropdownTrigger()
      )}
      <PopoverContentDropdown
        onOpenAutoFocus={(event) => event.preventDefault()}
        side="bottom"
        avoidCollisions={!!children}
        className="noflow nowheel nopan nodelete nodrag p-0"
        style={
          children
            ? {}
            : { minWidth: refButton?.current?.clientWidth ?? "200px" }
        }
      >
        <Command>
          {renderSearchInput()}
          {renderOptionsList()}
        </Command>
      </PopoverContentDropdown>
    </Popover>
  );
}
