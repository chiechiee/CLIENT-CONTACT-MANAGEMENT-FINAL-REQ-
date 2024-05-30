import tkinter as tk
from tkinter import messagebox
import sqlite3

class ContactManager:
    def __init__(self, root):
        self.root = root
        self.root.title("Contact Manager")

        # Connect to SQLite database
        self.conn = sqlite3.connect("contacts.db")
        self.cursor = self.conn.cursor()

        # Create contacts table if not exists
        self.cursor.execute('''CREATE TABLE IF NOT EXISTS contacts
                            (id INTEGER PRIMARY KEY, name TEXT, phone TEXT)''')
        self.conn.commit()

        # Labels
        tk.Label(root, text="Name:").grid(row=0, column=0, padx=5, pady=5)
        tk.Label(root, text="Phone:").grid(row=1, column=0, padx=5, pady=5)

        # Entry fields
        self.name_entry = tk.Entry(root)
        self.phone_entry = tk.Entry(root)
        self.name_entry.grid(row=0, column=1, padx=5, pady=5)
        self.phone_entry.grid(row=1, column=1, padx=5, pady=5)

        # Buttons
        tk.Button(root, text="Add Contact", command=self.add_contact).grid(row=2, column=0, columnspan=2, padx=5, pady=5)
        tk.Button(root, text="View Contacts", command=self.view_contacts).grid(row=3, column=0, columnspan=2, padx=5, pady=5)

    def add_contact(self):
        name = self.name_entry.get()
        phone = self.phone_entry.get()
        if name and phone:
            self.cursor.execute("INSERT INTO contacts (name, phone) VALUES (?, ?)", (name, phone))
            self.conn.commit()
            messagebox.showinfo("Success", "Contact added successfully!")
            self.clear_entries()
        else:
            messagebox.showerror("Error", "Please enter name and phone number.")

    def view_contacts(self):
        self.cursor.execute("SELECT * FROM contacts")
        contacts = self.cursor.fetchall()
        if contacts:
            contact_info = "\n".join([f"Name: {contact[1]}, Phone: {contact[2]}" for contact in contacts])
            messagebox.showinfo("Contacts", contact_info)
        else:
            messagebox.showinfo("Contacts", "No contacts found.")

    def clear_entries(self):
        self.name_entry.delete(0, tk.END)
        self.phone_entry.delete(0, tk.END)

if __name__ == "__main__":
    root = tk.Tk()
    app = ContactManager(root)
    root.mainloop()
