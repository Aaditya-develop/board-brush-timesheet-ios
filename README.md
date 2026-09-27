# Timesheet App

An iOS app for tracking employee work hours, built for a small business and shipped to the App Store, where it is used daily to log the hours that payroll depends on.

## Overview

This app lets employees clock their hours and lets the business track and manage them reliably. It was built end to end, from the data model and authentication through the day to day details of a tool that real people depend on. Because the output feeds real payroll, the app is built to handle failure cleanly and stay correct under everyday use rather than just in the happy path.

## Tech Stack

- **SwiftUI** for the user interface
- **Supabase** (PostgreSQL) for the backend and database
- **Supabase Auth** for authentication
- **Swift**

## Features

- Employee sign in and authentication
- Clock in and clock out to record work hours
- View and review logged hours
- Persistent storage of entries in a hosted database

## Architecture

The app follows an MVVM structure, with SwiftUI views backed by view models that talk to a Supabase layer for data and authentication. Hours are stored in a PostgreSQL database through Supabase, and the app handles network failures and invalid states so that a dropped connection or a bad entry does not corrupt the record.

## Running Locally

1. Clone the repo
2. Open the project in Xcode
3. Add your own Supabase project URL and anon key to a local configuration file (do not commit real keys)
4. Build and run on a simulator or device

> Note: this app connects to a Supabase backend. To run it yourself you will need your own Supabase project and credentials. No real business data or keys are included in this repo.

## What I Learned

Shipping to real users changed how I work. An edge case stops being hypothetical when someone's paycheck depends on the hours being right, so I learned to test carefully, handle failure states cleanly, and keep the system stable as I added to it.

## Status

Live on the App Store and in daily use by the business.
