-- Add email column to profiles table
ALTER TABLE public.profiles 
ADD COLUMN email text;

-- Update the handle_new_user function to include email
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
BEGIN
  -- Insert into profiles table
  INSERT INTO public.profiles (id, full_name, avatar_url, email)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'New User'),
    NEW.raw_user_meta_data->>'avatar_url',
    NEW.email
  );
  
  -- Assign default creator role
  INSERT INTO public.user_roles (user_id, role)
  VALUES (NEW.id, 'creator');
  
  RETURN NEW;
END;
$function$;

-- Update existing profiles with emails from auth.users
UPDATE public.profiles
SET email = auth.users.email
FROM auth.users
WHERE profiles.id = auth.users.id
AND profiles.email IS NULL;