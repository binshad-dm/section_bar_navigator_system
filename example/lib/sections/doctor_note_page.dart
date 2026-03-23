import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DoctorNotePage extends StatefulWidget {
  const DoctorNotePage({super.key});

  @override
  State<DoctorNotePage> createState() => _DoctorNotePageState();
}

class _DoctorNotePageState extends State<DoctorNotePage> {
  final TextEditingController _noteController = TextEditingController();
  final List<DoctorNote> _notes = [];
  String _selectedCategory = 'General';
  bool _isImportant = false;

  final List<String> _categories = [
    'General',
    'Patient Consultation',
    'Treatment Plan',
    'Follow-up',
    'Emergency',
    'Research',
    'Meeting Notes',
  ];

  @override
  void initState() {
    super.initState();
    // Add some dummy notes for demonstration
    _addDummyNotes();
  }

  void _addDummyNotes() {
    _notes.addAll([
      DoctorNote(
        id: '1',
        title: 'Patient Consultation - John Doe',
        content: 'Patient complains of chest pain. ECG shows normal sinus rhythm. Prescribed pain medication and advised to return if symptoms worsen.',
        category: 'Patient Consultation',
        isImportant: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      DoctorNote(
        id: '2',
        title: 'Treatment Plan - Diabetes Management',
        content: 'Started patient on Metformin 500mg twice daily. Monitor blood sugar levels weekly. Schedule follow-up in 2 weeks.',
        category: 'Treatment Plan',
        isImportant: true,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      DoctorNote(
        id: '3',
        title: 'Research Notes - New Antibiotics',
        content: 'Reading about new generation antibiotics. Promising results in treating resistant strains. Need to review clinical trials.',
        category: 'Research',
        isImportant: false,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);
  }

  void _addNewNote() {
    if (_noteController.text.trim().isNotEmpty) {
      final newNote = DoctorNote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _noteController.text.trim(),
        content: _noteController.text.trim(),
        category: _selectedCategory,
        isImportant: _isImportant,
        timestamp: DateTime.now(),
      );

      setState(() {
        _notes.insert(0, newNote);
        _noteController.clear();
        _selectedCategory = 'General';
        _isImportant = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note added successfully!'),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note deleted successfully!'),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleImportant(String id) {
    setState(() {
      final noteIndex = _notes.indexWhere((note) => note.id == id);
      if (noteIndex != -1) {
        _notes[noteIndex] = _notes[noteIndex].copyWith(
          isImportant: !_notes[noteIndex].isImportant,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
     
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Add Note Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Note',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Note Input
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Write your note here...',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 16),
        
                  // Category and Important Toggle
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              isExpanded: true,
                              items: _categories.map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(
                                    category,
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategory = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _isImportant,
                            onChanged: (bool? value) {
                              setState(() {
                                _isImportant = value!;
                              });
                            },
                            activeColor: Colors.orange[600],
                          ),
                          Text(
                            'Important',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
        
                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addNewNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add Note',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
            //        CallSliderButton(
            //   onAccept: () => debugPrint("Call accepted!"),
            //   onDecline: () => debugPrint("Call declined!"),
            // ),
                ],
              ),
            ),
        
            // Notes List
            _notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notes yet',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first note above',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(note.category).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getCategoryIcon(note.category),
                              color: _getCategoryColor(note.category),
                              size: 20,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  note.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              if (note.isImportant)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Important',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                note.content,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(note.category).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      note.category,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: _getCategoryColor(note.category),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    DateFormat('MMM dd, HH:mm').format(note.timestamp),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                            onSelected: (String value) {
                              if (value == 'toggle_important') {
                                _toggleImportant(note.id);
                              } else if (value == 'delete') {
                                _deleteNote(note.id);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'toggle_important',
                                child: Row(
                                  children: [
                                    Icon(
                                      note.isImportant
                                          ? Icons.star_border
                                          : Icons.star,
                                      color: Colors.orange[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      note.isImportant
                                          ? 'Remove Important'
                                          : 'Mark Important',
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.red[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Patient Consultation':
        return Colors.blue;
      case 'Treatment Plan':
        return Colors.green;
      case 'Follow-up':
        return Colors.orange;
      case 'Emergency':
        return Colors.red;
      case 'Research':
        return Colors.purple;
      case 'Meeting Notes':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Patient Consultation':
        return Icons.people;
      case 'Treatment Plan':
        return Icons.medical_services;
      case 'Follow-up':
        return Icons.schedule;
      case 'Emergency':
        return Icons.emergency;
      case 'Research':
        return Icons.science;
      case 'Meeting Notes':
        return Icons.meeting_room;
      default:
        return Icons.note;
    }
  }
}

class DoctorNote {
  final String id;
  final String title;
  final String content;
  final String category;
  final bool isImportant;
  final DateTime timestamp;

  DoctorNote({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.isImportant,
    required this.timestamp,
  });

  DoctorNote copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    bool? isImportant,
    DateTime? timestamp,
  }) {
    return DoctorNote(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      isImportant: isImportant ?? this.isImportant,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
