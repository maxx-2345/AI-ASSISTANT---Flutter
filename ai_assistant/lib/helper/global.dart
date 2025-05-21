// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// const appName = 'AI ASSISTANT';

// late Size mq;

// final apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
// final imageApiKey = dotenv.env['HUGGING_FACE_KEY'] ?? '';


import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const appName = 'AI Assistant';
late Size mq;

// API Keys
final apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
final huggingFaceKey = dotenv.env['HUGGING_FACE_KEY'] ?? ''; 