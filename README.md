# The Family Record

A private, shared family tree.

Sign-in is by emailed link — no passwords. Only email addresses on the family
list can see or change anything; everyone else gets nothing, whatever they try.

## Setting it up (about five minutes, once)

1. **Create the database.** Go to [supabase.com](https://supabase.com), sign up (free),
   and create a new project. Any name and region will do; pick a strong database
   password and keep it.

2. **Create the tables.** In the project, open **SQL Editor**, paste the whole of
   [`schema.sql`](schema.sql), and press **Run**. That creates the tables and locks
   them down so only the family list can read or write.

3. **Add the family.** At the bottom of `schema.sql` there is an `allowed_emails`
   list. Add a line per person and Run it again.
   Adding someone here is the *only* way anyone gets access.

4. **Connect the app.** In Supabase go to **Project Settings → API** and copy two
   things: the **Project URL** and the **anon public** key. Paste them into
   [`config.js`](config.js), then commit and push.

5. **Allow the sign-in links back.** In Supabase go to
   **Authentication → URL Configuration** and add the published site address to
   **Redirect URLs**, so the emailed links land back on the app.

That's it. Anyone on the list opens the site, types their email, clicks the link
in their inbox, and they're in.

## How it works

- **One record per person**, so two people editing at the same time never
  overwrite each other.
- **Everything saves itself** as you type.
- **Live**: changes appear in everyone's browser straight away.
- **Every fact is marked** *Verified from a record*, *Family memory*, or
  *Please check this* — so you can always tell evidence from recollection.
- **Export** produces a GEDCOM file that opens in any genealogy software.

## A note on what is public

This repository holds only the code. **No family information is stored here** —
it all lives in your Supabase database behind the sign-in. The two values in
`config.js` are designed to be public and grant no access on their own.
