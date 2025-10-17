import { cn } from "@/lib/utils";

function IOSSkeleton({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn(
        "animate-pulse rounded-lg bg-gray-200 dark:bg-gray-800",
        className
      )}
      {...props}
    />
  );
}

export { IOSSkeleton };