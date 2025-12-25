<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Event;
use Illuminate\Http\Request;

class EventController extends Controller
{
    public function index(Request $request)
    {
        $events = Event::with(['creator', 'creator.profile', 'participants'])
            ->where('event_date', '>=', now())
            ->orderBy('event_date', 'asc')
            ->get()
            ->map(function ($event) use ($request) {
                return [
                    'id' => $event->id,
                    'title' => $event->title,
                    'description' => $event->description,
                    'location' => $event->location,
                    'event_date' => $event->event_date,
                    'contact' => $event->contact,
                    'image' => $event->image,
                    'creator' => [
                        'id' => $event->creator->id,
                        'phone_number' => $event->creator->phone_number,
                        'country_code' => $event->creator->country_code,
                        'profile' => $event->creator->profile,
                    ],
                    'participants_count' => $event->participants()->count(),
                    'participants' => $event->participants()->pluck('user_id')->toArray(),
                    'has_joined' => $request->user() ? $event->hasUserJoined($request->user()->id) : false,
                    'is_owner' => $request->user() ? $event->user_id === $request->user()->id : false,
                    'created_at' => $event->created_at,
                    'updated_at' => $event->updated_at,
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $events,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'location' => 'required|string|max:255',
            'event_date' => 'required|date_format:Y-m-d H:i|after:now',
            'image' => 'nullable|string',
        ]);

        $image = null;
        if (!empty($validated['image'])) {
            // Clean and validate base64 string
            $image = trim($validated['image']);
            if (!$this->isValidBase64($image)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid image format',
                ], 422);
            }
        }

        $event = Event::create([
            'user_id' => $request->user()->id,
            'title' => $validated['title'],
            'description' => $validated['description'],
            'location' => $validated['location'],
            'event_date' => $validated['event_date'],
            'contact' => $request->user()->phone_number,
            'image' => $image,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Event created successfully',
            'data' => $event,
        ], 201);
    }

    public function update(Request $request, $eventId)
    {
        $event = Event::findOrFail($eventId);

        // Check if user is owner
        if ($event->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized to edit this event',
            ], 403);
        }

        $validated = $request->validate([
            'title' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'location' => 'sometimes|string|max:255',
            'event_date' => 'sometimes|date_format:Y-m-d H:i|after:now',
            'image' => 'sometimes|nullable|string',
        ]);

        if (!empty($validated['image'])) {
            // Clean and validate base64 string
            $validated['image'] = trim($validated['image']);
            if (!$this->isValidBase64($validated['image'])) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid image format',
                ], 422);
            }
        }

        $event->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Event updated successfully',
            'data' => $event,
        ]);
    }

    public function destroy(Request $request, $eventId)
    {
        $event = Event::findOrFail($eventId);

        // Check if user is owner
        if ($event->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized to delete this event',
            ], 403);
        }

        $event->delete();

        return response()->json([
            'success' => true,
            'message' => 'Event deleted successfully',
        ]);
    }

    public function join(Request $request, $eventId)
    {
        $event = Event::findOrFail($eventId);
        $userId = $request->user()->id;

        // Check if already joined
        if ($event->hasUserJoined($userId)) {
            return response()->json([
                'success' => false,
                'message' => 'You already joined this event',
            ], 400);
        }

        $event->participants()->attach($userId);

        return response()->json([
            'success' => true,
            'message' => 'Joined event successfully',
        ]);
    }

    public function leave(Request $request, $eventId)
    {
        $event = Event::findOrFail($eventId);
        $userId = $request->user()->id;

        // Check if owner can't leave (must delete instead)
        if ($event->user_id === $userId) {
            return response()->json([
                'success' => false,
                'message' => 'Event creator cannot leave. Please delete the event instead.',
            ], 400);
        }

        $event->participants()->detach($userId);

        return response()->json([
            'success' => true,
            'message' => 'Left event successfully',
        ]);
    }

    private function isValidBase64(string $str): bool
    {
        if (empty($str)) {
            return false;
        }
        // Remove whitespace
        $str = trim($str);
        // Check if string is valid base64
        if ((bool) preg_match('/^[a-zA-Z0-9+\\/]*={0,2}$/', $str) === false) {
            return false;
        }
        // Validate by decoding
        if (base64_decode($str, true) === false) {
            return false;
        }
        // Check if length is valid (must be multiple of 4 when padded)
        return (strlen($str) % 4) === 0;
    }
}
